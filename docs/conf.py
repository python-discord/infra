# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = "DevOps"
copyright = "2024, Python Discord"
author = "Joe Banks <joe@jb3.dev>, King Arthur <king-arthur@pydis.wtf>"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = []

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = "alabaster"
html_static_path = ["_static"]
html_theme_options = {
    "logo": "logo.png",
    "logo_name": True,
    "logo_text_align": "center",
    "github_user": "python-discord",
    "github_repo": "infra",
    "github_button": True,
    "extra_nav_links": {
        "DevOps on YouTube": "https://www.youtube.com/watch?v=b2F-DItXtZs",
        "git: Infra": "https://github.com/python-discord/infra/",
        "git: King Arthur": "https://github.com/python-discord/king-arthur/",
        "Kanban Board": "https://github.com/orgs/python-discord/projects/17/views/4",
    },
}
