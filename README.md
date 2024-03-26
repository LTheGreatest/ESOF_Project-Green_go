# _GreenGo_ Development Report

Welcome to the documentation pages of the _GreenGo_!

You can find here details about the _GreenGo_, from a high-level vision to low-level implementation decisions, a kind of Software Development Report, organized by type of activities:

This project is part of the Software Engineering UC.
The main goal is to build a mobile app that addresses the sustainable development in the context of hte academic community.
The app will try to encourage the FEUP community to have better practises regarding sustainable development.

* [Business modeling](#business-modelling)
  * [Product Vision](#product-vision)
  * [Features and Assumptions](#features-and-assumptions)
  * [Elevator Pitch](#elevator-pitch)
* [Requirements](#requirements)
  * [User stories](#user-stories)
  * [Domain model](#domain-model)
* [Architecture and Design](#architecture-and-design)
  * [Logical architecture](#logical-architecture)
  * [Physical architecture](#physical-architecture)
  * [Vertical prototype](#vertical-prototype)
* [Project management](#project-management)

Contributions are expected to be made exclusively by the initial team, but we may open them to the community, after the course, in all areas and topics: requirements, technologies, development, experimentation, testing, etc.

Please contact us!

Thank you!

* **Lucas Faria** (up202207540)

* **Pedro Borges** (up202207552)

* **Manuel Mo** (up202205000)

* **Rafael Campeão** (up202207553)

* **Alexandre Lopes** (up202207015)

* **Diogo Santos** (up202009291)

## Business Modelling

### Product Vision

An app to encourage the public to use sustainable mobility by turning the process into a game.

### Features and Assumptions

#### Features

* **Point System** - A system that rewards the user when he uses sustainable means of transport.

* **Leaderboard** - A leaderboard system that shows the top community members in terms of points. The members in the top of the leaderboard may receive some prizes.

* **Selection of transports** - The user can select some different means of transport to start counting the points/receive the points.

* **Verification** - The user may need to give some information to the system so that it can verify if the travel was made using sustainable means of transport.

#### Dependencies

* Information about bus stops

### Elevator Pitch

Draft a small text to help you quickly introduce and describe your product in a short time (lift travel time ~90 seconds) and a few words (~800 characters), a technique usually known as elevator pitch.

Take a look at the following links to learn some techniques:

* [Crafting an Elevator Pitch](https://www.mindtools.com/pages/article/elevator-pitch.htm)
* [The Best Elevator Pitch Examples, Templates, and Tactics - A Guide to Writing an Unforgettable Elevator Speech, by strategypeak.com](https://strategypeak.com/elevator-pitch-examples/)
* [Top 7 Killer Elevator Pitch Examples, by toggl.com](https://blog.toggl.com/elevator-pitch-examples/)

## Requirements

In this section, you should describe all kinds of requirements for your module: functional and non-functional requirements.

### User stories
>
> [!Caution] This section will _not_ exist in your report, it is here only to explain how you should describe the requirements of the product as **user stories**.

The user stories should be created as GitHub items in the Project board.

A user story is a description of desired functionality told from the perspective of the user or customer. A starting template for the description of a user story is *As a < user role >, I want < goal > so that < reason >.*

User stories should be created and described as items in your GitHub Project with the label "user story".

You should name the item with either the full text of the user story or a shorter name, up to you, and, in the "comments" field, add all relevant notes, the image(s) of the user interface mockup(s) (see below) and the acceptance test scenarios (see below), linking to its acceptance test in Gherkin, whenever available.

**INVEST in good user stories**.
You may add more details after, but the shorter and complete, the better. In order to decide if the user story is good, please follow the [INVEST guidelines](https://xp123.com/articles/invest-in-good-stories-and-smart-tasks/).

**User interface mockups**.
After the user story text, you should add a draft of the corresponding user interfaces, a simple mockup or draft, if applicable.

**Acceptance tests**.
For each user story you should write also the acceptance tests (textually in [Gherkin](https://cucumber.io/docs/gherkin/reference/)), i.e., a description of scenarios (situations) that will help to confirm that the system satisfies the requirements addressed by the user story.

**Value and effort**.
At the end, it is good to add a rough indication of the value of the user story to the customers (e.g. [MoSCoW](https://en.wikipedia.org/wiki/MoSCoW_method) method) and the team should add an estimation of the effort to implement it, for example, using points in a kind-of-a Fibonnacci scale (1,2,3,5,8,13,20,40, no idea).

### Domain model

To better understand the context of the software system, it is very useful to have a simple UML class diagram with all the key concepts (names, attributes) and relationships involved of the problem domain addressed by your module.
Also provide a short textual description of each concept (domain class).

Example:

![Domain Model](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/blob/main/images/DomainModel.png)

## Architecture and Design

The architecture of a software system encompasses the set of key decisions about its overall organization.

A well written architecture document is brief but reduces the amount of time it takes new programmers to a project to understand the code to feel able to make modifications and enhancements.

To document the architecture requires describing the decomposition of the system in their parts (high-level components) and the key behaviors and collaborations between them.

In this section you should start by briefly describing the overall components of the project and their interrelations. You should also describe how you solved typical problems you may have encountered, pointing to well-known architectural and design patterns, if applicable.

### Logical architecture

The GreenGo App relies on several external dependencies to enhance user experience and functionality. These include verification protocols for completed missions, GPS integration for precise point calculation, camera access to capture images for specific tasks, and a robust database system to securely store both user and mission data.

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/assets/133124561/b8421577-d688-4515-8c2d-36ec0af54734)


### Physical architecture

The user enters the GreenGo app through his smartphone. In the app he can see the leaderboard, profile, missions, he can use even the camera and turn on the GPS. When the user wants to see some data, like his profile. The "User Controller" goes to the database server and enters the "User Database" to find the data about his profile. The same goes to if the user wishes to view the leaderboard or the missions to complete. 

The camera and the GPS is for the validation of his mission. For example, if he is doing a mission that is making a trip with public transport, he uses the GPS and the "GPS Controller" sends the data of the GPS to the "Backend Server" to verify if is valid. The same goes to the camera. The user takes pictures to prove the completion of the mission and then the "Camera Controller" Sends it to the "Verification" sector. Also this two components are allowed to be used in the app because of the "Smatphone Controller" which enables all functions.

![image](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/assets/133124561/53239480-3e58-4eae-93ee-19e41655d2cd)

### Other diagrams


* Class diagram:

<img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/assets/133124561/a2ea3ac5-0c67-4f1d-9032-15cd6b877c90" alt="Class Diagram" style="width:300px">

* SequenceDiagram:

<img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/assets/133124561/f83cca47-d0fb-42da-8168-d05bc6729e96" alt="Sequence Diagram" style="width:300px">

* State Diagram:

<img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/assets/133124561/fa8c5b7d-1df4-4c37-9819-0bd1b8d1b1f4" alt="State Diagram" style="width:300px">

* Activity Diagram:

<img src="https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/assets/133124561/188e89f4-7987-4cea-9c30-308823bcb146" alt="Activity Diagram" style="width:300px">



#### Vertical prototype

To help on validating all the architectural, design and technological decisions made, we usually implement a vertical prototype, a thin vertical slice of the system integrating as much technologies we can.

In this subsection please describe which feature, or part of it, you have implemented, and how, together with a snapshot of the user interface, if applicable.

At this phase, instead of a complete user story, you can simply implement a small part of a feature that demonstrates they you can use the technology, for example, show a screen with the app credits (name and authors).

## Project management

Software project management is the art and science of planning and leading software projects, in which software projects are planned, implemented, monitored and controlled.

In the context of ESOF, we recommend each team to adopt a set of project management practices and tools capable of registering tasks, assigning tasks to team members, adding estimations to tasks, monitor tasks progress, and therefore being able to track their projects.

Common practices of managing iterative software development are: backlog management, release management, estimation, iteration planning, iteration development, acceptance tests, and retrospectives.

You can find below information and references related with the project management in our team:

* Backlog management: Product backlog and Sprint backlog in a [Github Projects board](https://github.com/orgs/FEUP-LEIC-ES-2023-24/projects/64);
* Release management: [v0](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/releases/tag/v0.0.1), [v1](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/releases/tag/v0.1.0), [v2](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/releases/tag/v0.2.0), [v3](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC10T2/releases/tag/v0.3.0), v...;
* Sprint planning and retrospectives:
  * plans: screenshots of Github Projects board at begin and end of each iteration;
  * retrospectives: meeting notes in a document in the repository;
