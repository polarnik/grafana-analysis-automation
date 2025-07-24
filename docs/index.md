---
marp: true
paginate: false
unknown-size: true

---


<!-- _class: lead
transition: fade 500ms
-->
 
# How to *automate* Grafana dashboard *analysis*

## Viacheslav Smirnov

---

![bg h:100%](img/it-projects.png)

---

![bg h:100%](img/it-projects-1.png)

---

![bg h:100%](img/it-projects-2.png)

---

![bg h:100%](img/it-projects-3.png)

---

<!--
_transition: cube 1000ms
-->

# How to *automate*

- ## Generation via **jsonnet**
- ## **Visual hints** for analysis
- ## Alerts, run-books, links, snapshots and issues


---

<!--
_transition: melt 1000ms
-->

# Dashboards as code
## with jsonnet

- ## GitOps
- ## Query management
- ## Design patterns
- github.com/polarnik/grafana-analysis-automation

![bg right](img/qr-code-github.svg)

---

<!-- _class: lead
_transition: cube 1000ms
-->

# Dashboards as code 
## *Demo*

---

# Visual hints

- ## Change points
- ## Priorities
- ## Navigation

---

# Visual hints

- ## *Change points*
- ## Priorities
- ## Navigation

---



# *Change points* will show the most important events

- ## Releases
- ## Restarts
- ## Settings updates

---

<!-- _class: lead
-->

# 💡 Top level panel with versions can show _Release_ moments

---

<!-- _class: lead
_transition: melt 1000ms
-->

# 💡 Annotations can show _Restarts_ and _Settings updates_


---

<!-- _class: lead
-->

# Change points 
## *Demo*


---

<!-- _class: lead
-->

# Next step: to use a *rollback plan* checklist with *step-by-step* instructions

---

<!-- _class: lead
_transition: cube 1000ms
-->

# Next step:
# *hot-fix*

---

# Visual hints

- ## Change points
- ## *Priorities*
- ## Navigation

---

# *Priorities* will highlight bottlenecks

- ## Simple dashboards
- ## TOPs
- ## Gradients

---

# Meta dashboards

![bg contain](img/meta-1.png)
![bg contain](img/meta-2.png)

---
# Simple dashboards

![bg fit](img/simple-1.png)
![bg fit](img/simple-2.png)

---

![bg fit](img/meta-2.png)
![bg fit](img/simple-2.png)

---

# Simplify dashboards via the code
```jsonnet
      row.new('🗂 File Descriptors'),
      
      panels.combo.stat.a_bigger_value_is_a_problem(
        '🗂 FDS', 
        queries.diff_over_time(queries.process.open_fds)
      ),
      
      panels.combo.timeSeries.current_vs_prev(
        '🗂 FDS', 
        queries.start_prev_current_diff(queries.process.open_fds), 
        queries.process.open_fds.unit
      ),
```

---

# TOPs in Tables is my favorite
## We can sort by the Total Duration

![bg](img/top-1.png)

---

# TOPs in Legends is the easiest way
## We can sort by Mean

![bg](img/top-2.png)

---

# TOPs in Time Series

![bg](img/top-3.png)

---

# Gradients

---

<!-- _class: lead
_transition: cube 1000ms
-->

# Priorities: Simple dashboards with TOPs and Gradients
## *Demo*

---

# Visual hints

- ## Change points
- ## Priorities
- ## *Navigation*

---


# *Navigation* will save your time

- ## Summary and Templates
- ## Links
- ## Schemas



---

# Navigation through Summary and Templates dashboards

- ## Summary dashboard 
  - ## uses *Tables* and *Stat* panels
- ## Template dashboards 
  - ## use *Time series* with *Text* variables

---

# Links will connect relevant dashboards

- ## Table cells links through *Data links*
- ## Stats panel links through *Data links*
- ## Dashboard links through *Tags*
- ## Diagram Links through *Actions*
- ## Text Links through *HTML* or *Markdown*
- ## Panel links

---


<!--
_transition: melt 1000ms
-->

# Schemas will visualize connections

- ## The Diagram plugin with *Mermaid.js* Flowchart
- ## The Text panel with images of *Miro* diagrams

---

<!-- _class: lead
_transition: cube 1000ms
-->

# Navigation
# *Demo*

---

# Hints for automation analysis

## Run-books
- Runbook templates
- Runbook-first alerts
- Markdown, Writerside, Hugo

---

# Hints for automation analysis

## Links in Alerts

- The runbook link
- Dashboard links with Time ranges
- Grafana annotations with links
- Issue links

---

<!-- _class: dark
-->


# Contacts

- ## perf**qa** (linkedin)
- ## **perf**track (grafana)
- ## smirnov**qa** (telegram)
- ## **qa**positive (gmail)
- ## polarnik (github)
