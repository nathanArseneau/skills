---
name: pdf-to-markdown
description: Convert a PDF (or page images) into one clean, faithful Markdown file by rendering each page to PNG with ImageMagick and transcribing the images visually. Use when the user asks to convert a PDF, scanned document, manual, API reference, or screenshots of pages to Markdown, especially when layout matters (tables, code samples, headings) and plain text extraction would mangle it.
---

# PDF to Markdown

Render every page to an image, read the images, and write the Markdown yourself. Visual transcription keeps tables, code blocks, and heading structure that `pdftotext` destroys.

## Available scripts

- **`scripts/merge.sh`** — Merges the individual Markdown files generated from each page into a single cohesive Markdown document.
- **`scripts/render.sh`** — Renders each page of the PDF to a PNG image at the specified DPI and in parallel.

## Workflow

### 1. Render the pages

```bash
bash scripts/render.sh <file.pdf> pages 150 8
```

- Renders each page separately (`page-001.png`, ...) at 150 DPI, 8 in parallel, on a white background. One `convert` call on the whole PDF runs out of ImageMagick's pixel cache on large files, so don't do that.
- 150 DPI is readable for normal body text and code. Use 200 if the PDF has very small print.
- If `convert` is missing, tell the user to install ImageMagick (and `poppler-utils` for `pdfinfo`).
- If the user gives page images instead of a PDF, skip this step.

### 2. Transcribe in batches of 6 pages

Loop until every page is done:

1. Read the next 6 page PNGs in parallel (one Read call each, all in the same response).
2. Write their Markdown to `md/<first>-<last>.md` with zero-padded page numbers (`001-006.md`). In the **same response**, also Read the next 6 pages, so each turn writes one batch and reads the next.
3. Continue content that runs across a page break straight into the next chunk: a table row, a code block, or a sentence that is cut off picks up where it stopped. Don't repeat table headers or reopen code fences that the page break split.

Before step 2 on the first batch, check the table of contents page (if any). It fixes the heading hierarchy and anchor names for the whole document.

Give the user a one-line progress note now and then (for example "pages 1–120 done"), since a long document takes many turns.

### 3. Transcription rules

- **Drop page furniture:** running headers ("10 | Chapter Name"), footers (document title), and page numbers.
- **Headings:** book/document title and each chapter `#`, sections `##`, subsections `###`, deeper `####`. Put `---` before each new chapter.
- **Table of contents:** turn it into a nested list of links to heading anchors (`[The login Service](#the-login-service)`). When a heading title repeats, the second anchor gets `-1`.
- **Cross-references:** blue in-document links become links to the heading anchor. Links whose URL isn't visible on the page stay plain text; don't invent URLs.
- **Code, JSON, XML, URLs, requests:** fenced code blocks with a language tag when obvious (`json`, `xml`, `html`). Keep the original indentation. Rejoin lines the PDF wrapped only because of page width (e.g. `rest_` / `v2/...`).
- **Inline code:** endpoint URLs, file paths, media types, property names, and literal values in backticks.
- **Tables:** GitHub pipe tables. Multi-paragraph or bullet cells use `<br>` (and `•` for bullets). Escape `|` inside cells as `\|`. Numeric code columns right-aligned. When a cell holds a multi-line code sample, use an HTML `<table>` with a blank line and a fenced block inside the cell. Merge two-row group headers into single column names.
- **Stacked "Method / URL", "Content-Type / Content", "Return Value" boxes** (common in API docs) become separate small tables, and an "Options" box becomes a bold **Options** label followed by a bullet list.
- **Notes, warnings, tips:** blockquotes starting with `> **Note:**`.
- **Faithfulness:** keep the source's wording, typos, and errors in code samples exactly as printed (e.g. a missing comma in JSON, a misspelled word). Don't fix, summarize, or reword. Keep duplicated sections if the source duplicates them.
- **Images/diagrams:** describe briefly in italics, e.g. `*[Figure: architecture diagram showing ...]*`, unless the user wants them extracted.

### 4. Merge and verify

```bash
bash scripts/merge.sh md <output>.md
```

This joins chunks in page order and prints the line/byte count, whether code fences are balanced (an odd count means a block is left open, so find and fix it), and every `#` heading. Compare the heading list against the source's table of contents.

Name the output after the PDF (`report.pdf` → `report.md`) in the same directory unless told otherwise.

### 5. Report

Tell the user briefly:
- where the file is and its size, and that fences are balanced and all chapters are present
- what was intentionally changed: removed headers/footers, heading levels, rejoined tables, link handling, source typos kept, any links left as plain text
- that `pages/` and `md/` remain, and ask whether to delete them (don't delete without asking)

## Notes

### Short inputs

For one or a few images, skip the scripts: read the image(s) and reply with the Markdown in a fenced block plus a few notes on choices made, then offer to save it to a file.

### Very long documents

Each page image costs a lot of context (a 350-page PDF uses about 600k tokens). For documents much longer than that, tell the user up front and suggest splitting the job, for example converting page ranges in separate sessions (the `md/` chunks and `merge.sh` make resuming easy: check which chunk files already exist and continue from the next page).
