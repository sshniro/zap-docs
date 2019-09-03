<a name="contribution"></a>Contributions Welcome!
=========================================

Contributions are welcome in all the following forms which improves the quality and content of the documentation.

## Ways to Contribute

There are many ways you can contribute to OWASP ZAP, both as a user and as a developer.

**1. Creating High-level API Docs**

    Create high level docs or example guides on how to use the APIs to perform any action/view with ZAP.
    The source files for the ZAP API documentation is hosted in Github. The repository is available at [Github](https://github.com/sshniro/zapdocs).
    The source files are in `Markdown` (md) format.
    
**2. REST API Documentation**

    Rest API is documented using the Open API specification. The specification could be improved by enhacing the description of 
    parameters/ results/ data types etc. The open API specification is avaiable in [Github](https://github.com/sshniro/zap-docs/blob/master/openapi.yaml).

**3. Feature Documentation**

    Feature documentation of the ZAP is avaiable in the [Github wiki](https://github.com/sshniro/zapdocs).


## How to Contribute

The ZAP API documentation is developed according to the [docs as code](https://www.writethedocs.org/guide/docs-as-code/) philosophy.
The most direct and effective way to contribute to the docs is to submit a pull request(PR) or raise an 
issue in the Github repository containing the docs content that you want to change.

There are 2 different workflows which you can use to make changes or PRs. Use what you are most comfortable with!

**1. "Edit this File on Github" Option**
    
You can edit the documentation in the browser via navigating to the relevant source file and clicking the edit this file button.
This workflow is recommended for minor changes, For example correcting typos/spellings/grammar etc.
For extensive changes, please use the local setup and editing option.

**2. Local Setup and Editing**
    
You can fork the repository in Github and submit the changes via [pull requests](https://help.github.com/en/articles/creating-a-pull-request-from-a-fork). 
Please see the local setup for API docs section to setup and render the docs locally.


<aside class="notice">
The API documentation (this document) is built from the master branch of ZapDocs using Slate.
</aside>

## Local Setup for API Docs

ZAP uses git for its code repository. 
To submit a documentation update, use the following steps:

**1. Clone the ZAP Docs repository:** 
    `git clone https://github.com/sshniro/zapdocs.git`
   
**2. Navigate to the cloned repository:** 
    `cd zapdocs`
    
**3. Use the following guide to install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)**

**4. To install the dependencies:** `$ bundle install`
        
**5. To start the server:** `$ bundle exec middleman server`

## Documentation Style

This style guide provides a set of editorial guidelines for anyone writing documentation for OWASP ZAP.

### Language and Grammar
 

* In general, use active voice (in which the grammatical subject of the sentence is the person or thing performing the action) 
instead of passive voice (in which the grammatical subject of the sentence is the person or thing being acted upon), though there are exceptions.

    Example:

    - Recommended: Send a query to the scan service. The zap sends the status of the scanning process.

    - Not recommended: The scan service is queried, and an status is sent.


* In general, use second person in your docs rather than first person—"you" (sometimes implicit) instead of "we."

* The documentation should be neutral, without judgements, opinions. Make sure you do not favor anyone, our community is great as a whole, 
there is no need to point who is better than the rest of us.

* When referencing a hypothetical person, such as “a user with a session cookie”, gender-neutral pronouns (they/their/them) should be used. For example, instead of:
    - he or she, use they
    - him or her, use them
    - his or her, use their
    - his or hers, use theirs
    - himself or herself, use themselves
    
* Please use appropriate, informative, rather formal language.
    
* When you're writing reference documentation for a method, phrase the main method description in terms of what it does 
("Gets," "Lists," "Creates," "Searches"), rather than what the developer would use it to do ("Get," "List," "Create," "Search").

    - Recommended: tasks.insert: Creates a new task on the specified task list.
    - Not recommended: tasks.insert: Create a new task on the specified task list.

### Principles of Good Style

* Check the spelling and grammar in your contributions. Most editors include a spell checker or have an available spell-checking plugin.

* Avoid disclaimers, opinions, and value judgements. Words like "easily", "just", and "simple" are loaded with assumptions. 
Something might seem easy to you, but be difficult for another person. Try to avoid these whenever possible.

* Use simple, to the point sentences without complicated jargon. Compound sentences, chains of clauses, and location-specific 
idioms can make text hard to understand and translate. If a sentence can be split in two, it probably should. Avoid semicolons. 
Use bullet lists when appropriate.

* Provide context. Don't use abbreviations without explaining them. Don't mention non zap contents without linking to them.
 
### Formatting

* For sections (Titles), use the following capitalization rules: Capitalization of the first word, and all other words, 
except for closed-class words.

    - Example - The Spider Tutorial with APIs
    
    
## Markdown Syntax

The API docs are created using the markdown files. This section explains the primary differences between standard Markdown rules 
and the Markdown rules that ZAP documentation uses.

#### Writing code

**Inline Code**

Put \``backticks`\` around the following symbols when used in text:

* Argument names: `input`, `x`, `tensor`
* Returned tensor names: `output`, `idx`, `out`
* Data types: `json`, `xml`, `html`
* File name: `test.py`, `/path-to-your-data/xml/example-name`

**Code block**                                              

Use three back ticks to open and close a code block. Specify the programming language after the first backtick group.

