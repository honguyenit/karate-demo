Feature: Books mock server

Background:
    * def books = read('classpath:conduitApp/mock/mockdata/books.json')
    * def uuid = function(){ return java.util.UUID.randomUUID() + '' }
    * configure responseHeaders = { 'Content-Type': 'application/json' }
    * def abortWithStatus = 
    """
    function(status, data)
    {
        karate.set("responseStatus", status);
        karate.set("response", {content: data});
        karate.abort();
    }
    """

Scenario: pathMatches('/books') && methodIs('get')
    * def responseStatus = 200
    * def response =  books

Scenario: pathMatches('/book') && methodIs('get') && paramExists('name')
    * def bookName = paramValue('name')
    * def index = books.findIndex(book => book.name.includes(bookName))
    * print 'found book index: ' + index
    * eval if (index != -1) { karate.set('response', books[index]); karate.set('responseStatus', 200) } else { karate.set('responseStatus', 404) }


    Scenario: pathMatches('/book/{id}') && methodIs('get')
        * def id = pathParams.id
        * def index = books.findIndex(book => book.id == id)
        * eval if (index != -1) { karate.set('response', books[index]); karate.set('responseStatus', 200) } else { karate.set('responseStatus', 404) }

    Scenario: pathMatches('/book') && methodIs('post')
        * print request
        * def book = request
        * def id = uuid()
        * book.id = id
        * books.push(book)
        * def response = book
        * def responseStatus = 200

# Delete a book
    Scenario: pathMatches('/book/{id}') && methodIs('delete')
        * def id = pathParams.id
        * def index = books.findIndex(book => book.id == id)
        * eval if (index != -1) { books.splice(index, 1); karate.set('responseStatus', 204) } else { karate.set('responseStatus', 404) }