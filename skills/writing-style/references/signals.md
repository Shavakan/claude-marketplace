# Autopilot signals

Patterns that make a reader assume the text was produced without attention. One instance is harmless. A cluster makes the reader stop reading charitably.

Each entry gives the pattern, an example, and the direction of the fix. The fix is never a synonym. If a replacement word would fill the same slot, the sentence still has the problem.

## Word level

| Pattern | Examples | Fix |
|---|---|---|
| Stock vocabulary | "delve", "tapestry", "testament to", "landscape", "leverage", "robust", "seamless", "crucial", "comprehensive", "streamline" | Name the specific property. "Robust" becomes "retries three times and survives a restart". |
| Intensifiers | "very", "incredibly", "extremely", "significantly" | Give the number or the comparison, or drop the word. |
| Sincerity markers | "honestly", "truly", "genuinely", "to be frank" | Delete. They imply the surrounding text is something less than sincere. |
| Stacked hedges | "this may potentially suggest", "it could perhaps be argued" | Hedge once, in the place the uncertainty applies, and say what it depends on. |
| Signposting | "It's worth noting that", "It's important to remember", "Let's dive in", "Here's the thing" | Delete the announcement and keep the content. |
| Stock openers | "In today's fast-paced world", "In the ever-evolving landscape of" | Start with the first sentence that carries information. |

## Sentence and paragraph structure

| Pattern | Example | Fix |
|---|---|---|
| Manufactured contrast | "It's not just a tool, it's a mindset." | State the positive claim. Keep a contrast only when someone holds the view being denied. |
| Reflexive threes | "fast, reliable, and scalable" | Count the real items. Two is fine, and so is four. |
| Staged reveal | "The result? Chaos." "Here's the kicker:" | State the point in a plain sentence. |
| Quotable closer | A short final line that restates the paragraph. | End on the last sentence that adds information. |
| Mechanical rhythm | Every sentence the same length, or a long-long-short pattern in each paragraph. | Let sentence length follow the content. |
| Rhetorical question as transition | "So what does this mean for your team?" | Answer it without asking it. |

## Edges of a response

| Pattern | Examples | Fix |
|---|---|---|
| Praise opener | "Great question!", "That's a fascinating point." | Start with the answer. |
| Acknowledgement opener | "Certainly!", "Absolutely, I can help with that." | Start with the answer. |
| Restating the request | "You asked how to configure X. To configure X…" | Start with the answer. |
| Recap closer | "In summary," followed by the body again. | Stop when the content ends. |
| Offer closer | "Let me know if you'd like me to…", "I hope this helps!" | Stop, or name the one concrete next step that depends on the reader. |

## Formatting

| Pattern | Fix |
|---|---|
| Headers on a short answer | Remove them. Headers are for documents a reader navigates. |
| Bullets that fragment reasoning | Rewrite as a paragraph so the "because" and "so" survive. |
| Bold scattered through the text | Keep bold for the few terms a skimming reader must not miss. |
| Emoji as section markers or bullets | Remove them. |
| A table for one-dimensional content | Use a list, or a sentence. |
| Dense em dashes | Split into two sentences, or restructure so the aside is not needed. |

## Content

| Pattern | Example | Fix |
|---|---|---|
| Generic sentence | "Security is an important consideration for any system." | Ask what this sentence says about this case. Say that, or cut it. |
| No position | "There are pros and cons to both approaches." | Recommend one and give the condition under which the other wins. |
| Explaining the known | Defining Git for a senior engineer. | Cut to what this reader does not already have. |
| Invented specifics | A statistic or quotation with no source. | Remove it, or find and cite the source. |
| Unrequested reassurance | "It's completely understandable to feel overwhelmed." | Drop it unless the reader asked for support. |
| Outsized enthusiasm | "This is an exciting improvement!" on a config change. | State what changed. |

## Work writing

| Pattern | Example | Fix |
|---|---|---|
| Process narration | "First I explored the codebase, then I examined the tests…" | Lead with the finding. Mention a step only if it changes what the reader should do. |
| Overclaimed success | "production-ready", "fully tested", "comprehensive solution" | Say what was run and what the result was. Say what was not checked. |
| Template scaffolding | Summary / Changes / Testing / Notes around a three-line change. | Size the description to the change. |
| Coined labels | "the fallback path", "the v2 flow" used without introduction. | Define on first use, or write out what it stands for. |
| Shorthand | "cfg → parser → validate, then emit" | Write the sentence, with its verbs and articles. |
| Narrating comments | `# added retry logic` | Delete. The history belongs in the commit message. |
| Changelog in a status update | A list of everything touched. | Give the state now, what is blocked, and what you need. |

## After editing

Check that removing a pattern did not install its sibling:

- em dash to semicolon or parenthesis
- "It's not X, it's Y" to "Rather than X, Y" or "Less X, more Y"
- "delve into" to "dig into"
- a recap closer to a one-line moral
- a group of three to a pair of pairs

If a sibling appears, the sentence is still built around a slot instead of a point. Rewrite it from the claim outward.
