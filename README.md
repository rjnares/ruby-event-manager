# Ruby Event Manager

This is a simple project which applies the concepts taught in the [Files and Serialization](https://www.theodinproject.com/lessons/ruby-files-and-serialization) section of the [Ruby](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby) course for the [Full Stack Ruby on Rails](https://www.theodinproject.com/paths/full-stack-ruby-on-rails) curriculum on [The Odin Project](https://www.theodinproject.com/).

## Project Description
This is less of a project and more of a tutorial that walks you through building an "event manager" application in several iterations. The application simply reads the contents of a local CSV file, cleans necessary data, uses cleaned data in a request to the [Google Civic Information API](https://developers.google.com/civic-information), parses response data, and uses parsed response data to write unique files using a single template.

## Skills Applied
Some of the core Ruby skills being applied in this project include:
* Manipulating file input and output
* Reading the contents of a CSV file
* Transforming read contents of a CSV file into a standardized data format
* Utilizing the standardized data to contact a remote service
* Parsing the response from a remote service and using it to populate a template with user data
