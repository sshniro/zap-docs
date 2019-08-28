<a name="some_examples"></a>Contribution
=========================================


The Documentation project provides standard guidelines to contribute to ZAPs documentation.

Following are some areas where we need support for contribution
1. Creating Example Guides/ High-level Docs
2. Enhance the ZAPs Open API specification

<aside class="notice">
The ZAP documentation is shaped by the docs as code philosophy.

The API documentation (this document) is built from the master branch of ZapDocs using Slate.
</aside>

## Setup

1. Clone the ZAP Docs repository: 
    `git clone https://github.com/sshniro/zapdocs.git`
   
2. Navigate to the cloned repository: 
    `cd zapdocs`
    
3. Install the dependencies and run the server
    
    `bundle install &&`
    `bundle exec middleman server` 

## Guidelines

### Language and Grammar
 
* For sections (Titles), use the following capitalization rules: Capitalization of the first word, and all other words, except for closed-class words:

    - Example - The Spider Tutorial with APIs

* Please use appropriate, informative, rather formal language;

* Do not place any kind of advertisements in the documentation;

* The documentation should be neutral, without judgements, opinions. Make sure you do not favor anyone, our community is great as a whole, 
there is no need to point who is better than the rest of us;

* In general, use active voice (in which the grammatical subject of the sentence is the person or thing performing the action) 
instead of passive voice (in which the grammatical subject of the sentence is the person or thing being acted upon), though there are exceptions.

    Example:
    - Recommended: Send a query to the service. The server sends an acknowledgment.

    - Not recommended: The service is queried, and an acknowledgment is sent.

* In general, use second person in your docs rather than first person—"you" (sometimes implicit) instead of "we."

* When referencing a hypothetical person, such as “a user with a session cookie”, gender-neutral pronouns (they/their/them) should be used. For example, instead of:
    - he or she, use they
    - him or her, use them
    - his or her, use their
    - his or hers, use theirs
    - himself or herself, use themselves
    
* When you're writing reference documentation for a method, phrase the main method description in terms of what it does ("Gets," "Lists," "Creates," "Searches"), rather than what the developer would use it to do ("Get," "List," "Create," "Search")

    - Recommended: tasks.insert: Creates a new task on the specified task list.
    - Not recommended: tasks.insert: Create a new task on the specified task list.
    
     
## Formatting


## Code Examples



