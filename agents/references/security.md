# Security Findings — Reference

Loaded when reviewing code that touches input handling, auth, secrets, persistence, or external calls. Each entry pairs the smell with a concrete pattern.

## Injection
**SQL injection**
- Smell: string-concatenated SQL, template literals into `query()`, ORM `.raw()` with user input.
- Fix: parameterized queries / prepared statements. Reject "but I escaped it" — escapes are footguns; bind variables are safe.

**Command injection**
- Smell: `exec(`, `child_process.exec(`, `subprocess.shell=True` with user-influenced strings.
- Fix: argv-form (`spawn(cmd, [args])`, `subprocess.run([...], shell=False)`), strict allowlists, never compose shell strings from input.

**Path traversal**
- Smell: `path.join(BASE, userInput)`, `open(BASE + userInput)`.
- Fix: resolve to absolute, then verify it starts with the BASE prefix; reject otherwise. Don't trust `..` filtering — `%2e%2e`, symlinks, and unicode tricks bypass naïve checks.

**XSS**
- Smell: `innerHTML = userInput`, `dangerouslySetInnerHTML`, server-rendered HTML without escaping.
- Fix: use the framework's escaping (React `{value}`, template-engine auto-escape). For deliberate HTML, sanitize via DOMPurify or equivalent.

**Insecure deserialization**
- Smell: `pickle.loads`, `yaml.load` without `SafeLoader`, Java `ObjectInputStream`.
- Fix: prefer JSON or schema-validated formats. If pickle/yaml is unavoidable, gate with an HMAC and a strict allowlist of types.

## Auth / authz
**Missing authorization on data access**
- Smell: route handler reads/writes by ID without checking `userId === resource.ownerId` (or RBAC rule).
- Fix: every data access must check the principal can act on the resource. Default-deny.

**JWT verification skipped**
- Smell: `jwt.decode()` (no verify), missing audience/issuer check, `algorithms: ['HS256', 'none']`.
- Fix: `jwt.verify()` with explicit allowed algorithms; never accept `none`; verify `aud`, `iss`, `exp`, `nbf`.

**Session fixation / CSRF**
- Smell: state-mutating GET endpoints, missing CSRF tokens on form posts, cookies without `SameSite`.
- Fix: state changes via POST/PUT/DELETE only; CSRF tokens or `SameSite=Strict|Lax` cookies; double-submit pattern for SPAs.

**Timing attacks on secret comparison**
- Smell: `if (token === expected)` for tokens, signatures, password hashes.
- Fix: constant-time compare (`crypto.timingSafeEqual`, `hmac.compare_digest`).

## Secrets
**Hardcoded credentials / API keys**
- Smell: token strings literal in source, AWS keys, Stripe keys, JWT secrets in code.
- Fix: env var or secret manager; rotate the leaked key (it's already in git history); add a pre-commit secret scanner.

**Logging secrets**
- Smell: `logger.info(req)` (whole request), `console.log({headers})` including Authorization, error stacks containing tokens.
- Fix: redact at the logger; never log Authorization headers or password fields; review error paths for leaks.

## Crypto
**Weak hash for passwords**
- Smell: MD5/SHA1/SHA256 used for passwords, `crypt()`, no salt, low iteration counts.
- Fix: bcrypt / argon2 / scrypt with cost factor tuned to current hardware. Never roll your own.

**Predictable randomness for secrets**
- Smell: `Math.random()`, `random.random()`, time-based tokens.
- Fix: `crypto.randomBytes`, `secrets.token_hex` for tokens / IDs / nonces.

## Network / external calls
**SSRF**
- Smell: server-side fetch of a user-supplied URL without restriction.
- Fix: allowlist hosts, block private IP ranges (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `127.0.0.0/8`, `169.254.0.0/16`, `::1`), follow redirects manually with re-validation.

**TLS verification disabled**
- Smell: `verify=False` in requests, `rejectUnauthorized: false` in node, custom CA bypass.
- Fix: keep verification on. If certificate pinning is the goal, do it correctly with a pinned cert, not by disabling.

**Open redirect**
- Smell: redirect target taken from query param without validation.
- Fix: allowlist destinations, or sign the redirect target server-side.

## Mass assignment / over-posting
**Smell:** `User.create(req.body)`, `Object.assign(user, req.body)`.
**Fix:** explicit allowlist of writable fields (`pick(req.body, ['name', 'email'])`); never trust the shape of input objects.
