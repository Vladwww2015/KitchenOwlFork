Thanks for wanting to contribute to KitchenOwl!

### Where do I go from here?

So you want to contribute to KitchenOwl? Great!

If you have noticed a bug, please [create an issue](https://github.com/TomBursch/KitchenOwl/issues/new) before starting any work on a pull request or get in contact by joining our [Matrix space](https://matrix.to/#/#kitchenowl:matrix.org).

### Fork & create a branch

If there is something you want to fix or add, the first step is to fork the repository.
[:fontawesome-brands-github: Frontend](https://github.com/TomBursch/KitchenOwl){ .md-button }
[:fontawesome-brands-github: Backend](https://github.com/TomBursch/KitchenOwl-backend){ .md-button }
[:fontawesome-brands-github: Website](https://github.com/TomBursch/KitchenOwl-website){ .md-button }

Next is to create a new branch with an appropriate name. The general format that should be used is

``` bash
git checkout -b '<type>/<description>'
```

The `type` is the same as the `type` that you will use for [your commit message](https://www.conventionalcommits.org/en/v1.0.0/#summary).

The `description` is a descriptive summary of the change the PR will make.

### General Rules

- All PRs should be rebased (with main) and commits squashed prior to the final merge process
- One PR per fix or feature

### Setup & Install
=== "Frontend"
    - [Install flutter](https://flutter.dev/docs/get-started/install)
    - Install dependencies: `flutter packages get`
    - Create empty environment file: `touch .env`
    - Run app: `flutter run`
=== "Backend"
    - Create a python environment `python3 -m venv venv`
    - Activate your python environment `source venv/bin/activate` (environment can be deactivated with `deactivate`)
    - Install dependencies `pip3 install -r requirements.txt`
    - Initialize/Upgrade the sqlite database with `flask db upgrade`
    - Run debug server with `python3 wsgi.py`
    - The backend should be reachable at `localhost:5000`
=== "Docs"
    - The docs are contained inside the frontend repository
    - [Install MkDocs](https://www.mkdocs.org/getting-started/)
    - [Install Material for MkDocs](https://squidfunk.github.io/mkdocs-material/getting-started/)
    - Run docs: `mkdocs serve`
=== "Website"
    - [Install Hugo](https://gohugo.io/getting-started/quick-start/)
    - Run website: `hugo server`

### Git Commit Message Style

This project uses the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) format.

Example commit messages:

```
chore: update gqlgen dependency to v2.6.0
docs(README): add new contributing section
fix: remove debug log statements
```