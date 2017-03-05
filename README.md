Feed Dat Pup
===

Convert EPUB and PDF files to plain text - the ultimate standard format.

## Usage

~~~sh
GET  /                  # home page
POST /extracts/pdf      # extract PDF text (pass url|file)
POST /extracts/epub     # extract EPUB text (pass url|file)
~~~

## PDF Example

~~~sh
curl localhost:4567/extracts/pdf -X POST --data 'url=http://www.pdf995.com/samples/pdf.pdf'
# JSON response
curl localhost:4567/extracts/pdf -X POST --data '{"url":"http://www.pdf995.com/samples/pdf.pdf"}' --header 'content-type: application/json'
# JSON response
~~~

Example PDF extraction response:

~~~json
{
    "info": {
        "Author": "Software 995",
        "CreationDate": "12/12/2003 17:30:12",
        "Creator": "Pdf995",
        "Keywords": "pdf, create pdf, software, acrobat, adobe",
        "Producer": "GNU Ghostscript 7.05",
        "Subject": "Create PDF with Pdf 995",
        "Title": "PDF"
    },
    "metadata": null,
    "pages": [
        "<page 1 text>",
        "<page 2 text>",
        "<page 3 text>"
    ],
    "text": "<combined text of all pages>",
    "url": "http://www.pdf995.com/samples/pdf.pdf",
    "version": 1.3
}
~~~

## Installation

~~~sh
# clone the repository...
bundle install
ruby app.rb
~~~
