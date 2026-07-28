---
marp: true
size: 16:9
theme: am_crimson
paginate: true
---

<!-- Deliberately no `headingDivider`. It inserts a slide break before every
     h2/h3, which strands a `<!-- _class: ... -->` directive on its own blank
     slide and leaves the heading unstyled on the next one. Use explicit `---`
     separators, as below. -->


<!-- _class: cover_a -->
<!-- _header: "" -->
<!-- _footer: "" -->
<!-- _paginate: "" -->

# Presentation Title

###### A subtitle for your talk

Your Name | your@email.com

---

##### Overview

- Topic one
- Topic two
- Topic three

---

<!-- The class directive and its heading must stay on the same slide —
     keep them together between `---` separators. -->
<!-- _class: trans -->
<!-- _footer: "" -->
<!-- _paginate: "" -->

## Section One

---

##### A Wide Figure

![#c #ns w:1050px](./figures/example.png)

Caption or takeaway line goes here.

<!-- Sizing: `h:`/`w:` are honoured exactly, so pick whichever dimension is
     the binding one — `w:` for wide figures, `h:` for tall ones. Give wide
     figures (aspect wider than ~2:1) a full-width slide like this rather
     than a column panel, which clamps width and wastes most of the slide.
     Usable content box is roughly 1123 x 540 CSS px on a slide with a title. -->

---

##### A Regular Slide

- Bullet point 1
- Bullet point 2
- Bullet point 3

---

<!-- _class: cols-2 -->

##### Two-Column Layout

<div class="ldiv">

**Left column**

Use `ldiv` and `rdiv` divs to create side-by-side content.

</div>

<div class="rdiv">

**Right column**

Works well for comparisons, text alongside images, etc.

</div>

---

<!-- _class: trans -->
<!-- _footer: "" -->
<!-- _paginate: "" -->

## Section Two

---

##### Slide with Code

```python
def hello():
    print("Hello, World!")
```

---

<!-- _class: bq-blue -->

##### Blockquote Slide

> This slide uses the `bq-blue` class to style blockquotes.
> Other options: `bq-red`, `bq-green`, `bq-purple`, `bq-black`.

---

<!-- `lastpage` is a two-row grid: `heading` then `icons`. Only the heading
     and a `.icons` div are placed — any other body content lands outside the
     named areas and renders below the colour band. Put secondary text in the
     icons div, or use a normal slide if you need real content here. -->
<!-- _class: lastpage -->
<!-- _header: "" -->
<!-- _footer: "" -->
<!-- _paginate: "" -->

# Thank You

<div class="icons">

Questions?

</div>
