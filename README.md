# Glossary standard

A [throughline](https://github.com/rhodium-org/throughline) graph that sets out the
model of a glossary: a glossary of other graphs, for people who did not build them,
and the means by which many graphs come to use the same names for the same things.

A graph a person and an AI build together grows a vocabulary nobody designed, and
nobody holds all of it. A newcomer's first questions are "what is an X?" and "how
does it know?". A glossary that follows this standard answers both. It holds each
concept **once**:
- its preferred name and a one-line definition;
- why it exists, what decides how it behaves, and one concrete example;
- the other names it goes by, and the names being retired.

Each concept is linked by **stamped** links to the items it was written from, so an
answer leads back to the graph, and a change to those items marks the entry for
review.

It is a standard, not a tool and not a glossary. It holds no terms, and says
nothing about how a glossary is written or rendered.
[`/tl:glossary`](https://github.com/rhodium-org/throughline-skills) is the skill
that writes, keeps and renders one.

## One concept, many audiences

A concept is not written for a reader; what is published is. So audiences are items
of their own (AUD), each saying what that reader already knows and asks.
- **An audience's glossary is a subset.** A term links `for` → each audience
  whose glossary holds it. Publishing for an audience selects those terms. Nothing
  is copied, so the audience's glossary cannot say something the glossary does not.
- **A gloss rewords one term for one audience** (GLOSS), where the term's own words
  do not serve that reader. Its text is the definition in their words; it may also
  reword the why, how it works and example. A gloss links to its term by a stamped
  `glosses`, so a change to the concept marks every audience's wording for review.

## Many glossaries, one vocabulary

Glossaries of different graphs name things differently. The standard borrows the
mapping vocabulary of [SKOS](https://www.w3.org/TR/skos-reference/), the W3C model
for thesauri.

- **Within a glossary:**
  - the term's title is its preferred name;
  - `aliases` are names in accepted use;
  - `deprecated_names` are names to retire;
  - `broader` says a term is a kind or part of another, `relates` that it bears on
    another, and `distinct_from` that it is easily confused with another.
- **Across glossaries:** a glossary composes another, typically a shared one the
  whole organisation keeps, and maps its terms onto that glossary's terms with
  stamped links:
  - `same_as`: the same concept (exactMatch);
  - `close_to`: usable in its place in most uses (closeMatch);
  - `broader_match`: the other term is broader (broadMatch);
  - `narrower_match`: the other term is narrower (narrowMatch).

That gives a measure of consistency, which a tool can report and a person can act
on:
- the same concept under two preferred names (`same_as` between terms whose titles
  differ);
- a retired name still used in an explained graph;
- a concept the shared glossary has no term for, unless the term says it is `local`;
- one name used for two concepts.

Each finding is put right where the name lives, in the graph that owns it. Nothing
renames anything on its own. Over time the vocabulary converges, one ratified change
at a time.

## Following the standard

A glossary is a graph of its own, kept beside the graphs it explains, never inside
one. It names this repository as its schema source, the graphs it explains as
ordinary sources, and any glossary it maps onto as a source too:

```toml
[[sources]]
namespace = "glossary"
url = "https://github.com/rhodium-org/throughline-glossary-standard"
ref = "v1.0.0"
schema = true

[[sources]]                       # a graph it explains
namespace = "app"
path = "../service"

[[sources]]                       # a glossary it maps onto
namespace = "estate"
url = "https://github.com/rhodium-org/estate-glossary"
ref = "main"
```

The glossary is checked against the declarations held here as items. They follow the
meta-standard
[rhodium-org/throughline-standard-standard](https://github.com/rhodium-org/throughline-standard-standard)
(namespace `meta`). It needs throughline 5.2.0 or later, the first release that
checks a link declared to run *outside* the follower (to any item of a graph it
composes) and writes list attributes.

## What a follower holds

| Register | Prefix | Holds | Attributes | Links (tl enforces the counts) |
|---|---|---|---|---|
| Glossary | GLS | exactly one: what the glossary covers | — | — |
| Audiences | AUD | one kind of reader | `knows`* | `derives_from` → exactly 1 GLS |
| Terms | TERM | one concept: the title is its preferred name, the text its one-line definition | `why`*, `how_it_works`*, `example`*, `aliases`, `deprecated_names` (lists), `local` | `derives_from` → exactly 1 GLS; `defined_from` → ≥ 1 outside item; `driven_by` → outside items; `shown_by` → exactly 1 outside item; `distinct_from`, `relates`, `broader` → TERMs; `for` → AUDs; `same_as`, `close_to`, `broader_match`, `narrower_match` → outside items |
| Glosses | GLOSS | one term worded for one audience: the text is the definition in their words | `why`, `how_it_works`, `example` | `glosses` → exactly 1 TERM; `for` → exactly 1 AUD |

`*` means required. A term's and a gloss's attributes are signed content, so a change
to any of them needs a new signature. *Outside* means an item of any register in a
graph the glossary composes, other than this standard.

## What is here

| Folder | Items |
|---|---|
| `vision/` INT | 1 |
| `registers/` REG | 5: GLS, AUD, TERM and GLOSS for followers; EX for this graph |
| `types/` TYPE | 3: Line, Text, Flag |
| `attributes/` ATTR | 10 |
| `link-types/` LT | 13: defined_from, driven_by, shown_by, distinct_from, relates, broader, for, glosses, same_as, close_to, broader_match, narrower_match; verifies (this graph's) |
| `links/` LINK | 16 |
| `examples/` EX | 10, one per conformance graph |
| `conformance/` | `explained` is a small deck maker. `shared-glossary` is a glossary of it, to map onto. `full-glossary` uses every declaration: two audiences, a gloss, a broader term, a deprecated name, and a `same_as` match onto the shared glossary. It passes. `no-source`, `own-source`, `no-shown`, `no-example`, `no-how`, `two-glossaries`, `gloss-no-audience` and `audience-no-knows` each break one declaration and fail for that one reason. `./conformance/check.sh` runs them. |
