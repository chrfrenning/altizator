# altizator
Javascript library tagging images for universal access using Azure Cognitive Services

## The Why
_Is your website universally accessible?_ Helping all users consume the information on your website is important, but difficult. One specifically challenging task is describing all images with sensible 'alt' tags to help visually impaired users understand the information conveyed in images. Remember, a photo can 'say more than a thousand words', yet we often tag images simplistically.

While all websites should strive for this, some industries are regulated and have a requirement for universal access and strict penalties if the regulations are not met.

## The Goal
The goal of this project is to create a safeguard mechanism for images published on a website. Once integrated - with a single line of javascript code - altizator will ensure all images on your website have a meaningful description.

## The How
Altizator consists of a small script that scans the webpage after it is loaded in the users browser, looking for images that do not have 'alt' tags properly set. When detected, it uses Azure Cognitive Services to describe the image and insert the description into the 'alt' tag. This ensures textual representations of your website - e.g. using screen readers - can convey meaningful information about all images.

Additionally, altizator consists of a serverless endpoint using Azure Functions. The function takes care of the communication with Azure Cognitive Services. For languages that are not natively supported by Cognitive Services, it also uses Azure Translation to extend the range of languages supported. Finally, results are cached in CosmosDB, which ensures high performance and lower cost than sending all requests to Cognitive Services.

## The Installation
To install altizator, follow these easy steps:

1. Ensure you have an Azure Subscription. Use a paid or free account.
2. Log into [Azure Shell using Bash](https://shell.azure.com/)
3. Paste the following line and hit enter to work the magic
4. When the script returns OK, it also provides you with a script tag to use in your production website
5. Test the stuff, then deploy

*TODO: NOTE TO SELF: Create the installation script*


## The quick test
If you just want a quick test, to see if this really works, drop in the following script line in your 'head' section or just before end of 'body' tag. This is _NOT FOR PRODUCTION_ use, and our instance will severely rate limit your requests, so don't drop this in anywhere serious. A good way to test this is to add the script using the Developer Console in your fav browser.

`` <script scr="cdn.altizator.org/latest.js"></script> ``

*TODO: NOTE TO SELF - Make this quick test stuff actually work*

## The Contributions
We'd very much like your contributions to this project. File issues anytime, for probs and ideas. Send pull requests. Help make the worlds website a more accessible place!
