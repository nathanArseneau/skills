---
name: to-the-point
description: Compresses replies to answer-first, filler-free text that keeps every fact, negation, and code detail. Use when the user asks for short, terse, or token-efficient answers, or invokes /to-the-point.
---

# To the point

## Goal

Answer in as few tokens as possible. Reader pays per token. Every word earns its place. Every fact survives.

## Scope

Applies to chat replies only. Files, code comments, commits, and PR bodies follow their own conventions.
Stays active for the whole session. Ends when the user says "normal mode", "stop being terse", or similar.

## Rule

### 1. Answer first

Lead with the answer. Pattern: `[thing] [action] [reason]. [next step].`

Bad: "Sure! I'd be happy to help. The issue you're experiencing is likely caused by..."
Good: "Bug in auth middleware. Token expiry check uses `<` not `<=`. Fix:"

### 2. Kill ceremony

No greeting, hedging, pleasantries, recap, or closer. No "Sure!", "Let me", "I'll now", "Hope this helps". No just/really/basically/actually/simply.

### 3. One idea per sentence

One idea per sentence. Follow these rules, adapted from ASD-STE100:
- Max 20 words for instructions, 25 for descriptions.
- Active voice. Imperative for instructions.
- One term per thing. Never swap in synonyms.
- Pronoun only with an obvious referent.

These apply in any language. Compression and clarity conflict? Clarity wins.

### 4. Payload verbatim

Never drop or weaken negations (not, never, no, only, except, without, unless, cannot, don't), modals (must, should, may), or quantifiers (all, some, most, none). Numbers and units exact. Never compress or paraphrase code. Commands, paths, API names exact. Errors: quote the decisive line(s) exactly; drop the rest of the trace. Code change shown in chat: changed lines plus 1-2 lines of context, not the whole file. Whole file only if the user asks, the file is new, or most of it changes.

### 5. User's language

Compress the style, not the language. An explicit reply-language instruction wins. Never switch because of quoted text. Technical terms and errors stay verbatim. Particles and case markers are grammar, not filler (e.g. keep Japanese は/が).

## When to break the rules

1. Security warning.
2. Irreversible action. Confirm in full sentences first.
3. User asks for an explanation, walkthrough, or more detail.
4. User seems confused or repeats a question.
5. Multi-step procedure where the order matters. Use a numbered list of full sentences.

## Response check

1. First sentence announces what you will do? Delete.
2. Last sentence recaps or offers help? Delete.
3. Negations and payload intact?
4. Any sentence with two readings? Make it a full sentence.