---
name: writing-style
description: Write and review prose so it reads as clear human writing instead of AI slop. Use whenever drafting text a person will read (PR descriptions, commit bodies, Slack messages, status updates, incident notes, reports, READMEs, docs, emails) and whenever the user asks to review, edit, tighten, humanize, or de-slop a draft, or says something sounds like AI or is hard to read.
---

# Writing Style

Readers give up on a text for two separate reasons, and each needs its own pass.

- **Unclear sentences** cost effort. The reader has to work out who did what, decode a phrase nobody would say, or hunt for the point.
- **Autopilot signals** cost trust. Stock vocabulary, reflexive structures, and imposed formatting tell the reader nobody was paying attention, so they start skimming.

Fix clarity first. A draft with every signal removed can still be unreadable, and a clear draft survives a stray signal.

## Before drafting

1. **State the point in two sentences.** If that fails, the problem is the thinking, and no amount of sentence polish will fix it. Work out the point first.
2. **Pick the reader.** Default to someone capable who does not share your context: they have not seen the code, the thread, or the labels you coined while working, and they are switching in from other work.
3. **Lead with what they need.** That is usually the conclusion or the decision you need from them. Background comes after, and only as much as the reader needs to trust the conclusion.

## Three checks for every sentence

### 1. Who does what?

Make the actor the subject and the action the verb. When an abstraction is the subject, the reader has to dig the real actor and action back out of nouns.

- Unclear: "A decision was made to roll back the deployment following the detection of elevated error rates."
- Clear: "We rolled back the deploy after error rates rose."

Passive voice is fine when the actor is unknown or beside the point ("the certificate was issued in 2023"). The fault is hiding the actor without a reason.

### 2. Would a person say this out loud?

Use the ordinary name for a thing. Watch for stacked nouns, invented compound labels, and "it" or "this" with more than one possible referent.

- Unclear: "Cache invalidation handling lives at the write-path boundary."
- Clear: "The service clears the cache after every write."

A label you coined during the work feels like vocabulary to you and means nothing to the reader. Say the longer thing it stands for, or define it once on first use.

### 3. Can a skimming reader find the point?

Put the main point in the main clause, near the front. Delete sentences that say nothing the reader can use.

- Unclear: "Given that the migration has no dependencies outside the users table, the plan is to run it once the backup completes."
- Clear: "I'll run the migration when the backup finishes. It only touches the users table."

## Autopilot signals

These are the families to watch for. The full catalog with examples and fixes is in `references/signals.md`; load it when reviewing someone's draft or when rereading your own draft of more than a few paragraphs.

- **Stock vocabulary:** "delve", "robust", "seamless", "leverage", "crucial", "comprehensive".
- **Filler and signposting:** announcing content instead of delivering it.
- **Sincerity markers and intensifiers:** "honestly", "truly", "incredibly".
- **Reflexive structures:** denying a claim nobody made, grouping in threes by habit, staging a reveal, closing a paragraph on a quotable line.
- **Openers and closers:** praising the question, recapping the text, offering more help.
- **Imposed formatting:** headers on short answers, bullets that fragment reasoning, scattered bold.
- **Empty content:** sentences that would fit any topic, hedges on every claim, no position taken.

Two things to know when removing them:

- **Suppressing a pattern tends to produce its sibling.** An em dash becomes a semicolon, and "It's not X, it's Y" becomes "Rather than X, Y". Restructure the sentence around its point instead of swapping the token.
- **Specificity is the usual cure.** Most signals fill a slot where a specific claim, number, name, or example should be. Find the specific thing, or cut the sentence.

## Work writing

PR descriptions, Slack messages, status updates, and reports are read by people who cannot skip them, so slop costs the most here.

- **Report findings, not process.** The reader wants what you found, how sure you are, and what you need from them. Leave out the sequence of things you tried unless it changes what they should do.
- **Claim only what you verified.** Say what was tested and how. Say what was not tested. "Production-ready" on something run once will be discovered, and then nothing else in the message is believed.
- **Scale structure to content.** A three-line change gets a three-line description. Skip the Summary / Changes / Testing template unless the content fills it.
- **Write full sentences.** Arrows, dropped articles, and undefined abbreviations save the writer time and charge it to the reader.
- **Format for navigation only.** Use headers when the reader will jump around, bullets for parallel items, and tables for comparisons across attributes. Keep reasoning in paragraphs, because bullets strip out the connecting words that made it reasoning.

## Reviewing or rewriting a draft

1. Read the draft once as its intended reader. Ask who that is only if the answer would change the edit.
2. Load `references/signals.md`.
3. Run the three sentence checks, then scan for signals.
4. Report the problems that cost the reader most, worst first. For each one, quote the text, name the fault, and give the rewrite. When a pattern recurs, show one or two instances and say how often it appears instead of listing all of them.
5. When rewriting, keep the author's facts, claims, and voice. Add no claims, and do not make the text longer. If a passage has no point to sharpen, say so instead of polishing it.
6. Reread your rewrite for sibling patterns.

Describe faults by their effect on the reader ("the actor is hidden, so I had to read this twice") instead of pronouncing that the text sounds like AI. The author can act on the first and can only argue with the second.

## Before sending

Reread the finished text as the reader who is arriving cold:

- Is the point in the first two sentences?
- Is there a sentence the reader would not miss?
- Is there a label or abbreviation they were never given?
- Does any claim go further than what was checked?
