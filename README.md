# Homelab 2025

Welcome to my Homelab 2025 project! This is a Monorepo for my homelab project. The goal of this project is to provide a single source of truth for all the services and infrastructure that make up my homelab.

Its very much a work in progress and i am constantly adding new services and infrastructure to it. The goal is to have a single place to document everything that is going on in my homelab.

Sometimes i'll do deep dives into specific services over on my blog [https://thecomalley.github.io/](https://thecomalley.github.io/) but for the most part this is a place to document everything that is going on in my homelab.

---

### Clouds

There are many clouds, but the ones the HomeLab deploys into are **[Azure](./clouds/azure/README.md)** (Since this is what i work with during my day job) and obviously **[OnPrem](./clouds/onprem/README.md)** given this is a **home**lab.

![](./docs/homelab.drawio.png)

---

### Environments

As is often the case with Homelab environments i have a family that consumes *some* of the services the Homelab provides. As such we can reffer to the following environments:

- **Home Production (prd)** This is any service anyone other than me uses. This includes things like the Plex, DNS etc.
  
- **Home Development (dev)** This is stuff only I care about and carries a slightly more relaxed SLA :P