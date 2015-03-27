Feature: Publishing a markdown file to Google's Blogging platform

  Scenario: Publish a markdown file
    Given I have configured my API key
    And I have the markdown file "hello_word.md" saved in my drafts:
      """
      ---
      title: "Hello world"
      publish_at: 2009-11-05
      ---
      ## Hello World

      This is an example.

      """
    When I publish the file "hello_word.md"
    Then I should have a new post on my blog under "/2009/11/hello-world.html" containing:
      """
      <h2>Hello World</h2>

      <p>This is an example.</p>

      """
