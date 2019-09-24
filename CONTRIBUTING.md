# Contributing to DCAN

# How do I give feedback about DCAN?

Send an email to DecentralizedCAN@gmail.com. Feedback or questions are welcome.

## Found a bug?

Please include in your message:
* What steps you took just before the bug.
* What you were expecting to happen when the bug happened.
* What actually happened - the buggy behaviour itself.
* What web browser you were using.

If you’re reporting a bug in the software and want to work with the team directly we invite you to bypass the feedback form and [submit an issue on Github](https://github.com/DecentralizedCAN/CAN/issues/new).

Before reporting an issue:
* Please have a brief look to see if the issue is already listed. If so please add any extra, clarifying information you can to the existing issue.

## Want to help develop DCAN?

This is a new project and help is welcome. I will work to expand this developer documentation.

Specs
* Ruby 2.5.1
* Rails 5.1.4
* PostgreSQL

Config variables
* ADMIN_EMAIL
* ADMIN_PASSWORD
* SERVER_HOST
* GROUP_NAME
* GROUP_ABBREVIATION

Setup
* Start Postgres
* Run 'bundle install'
* Run 'rails db:create'
* Run 'rails db:migrate'
* Run 'rails db:seed'
* Run 'rails server'