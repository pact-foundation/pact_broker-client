Do this to generate your change history

    $ git log --date=relative --pretty=format:'  * %h - %s (%an, %ad)' 'package/pact_broker-client-0.0.PRODVERSION'..'package/pact_broker-client-0.0.NEWVERSION'

#### 0.0.3 (2013-11-13)

* a3488bd - Fixing application/json+hal to application/hal+json (Beth, 2 days ago)
* 0fa89ef - Updating content type to match new Webmachine implementation. Removing redundant repository_url interaction. (Beth, 2 days ago)
* 9e1539e - Redoing the URLs yet again (Beth, 3 days ago)
* 9067b83 - Working on list latest pacts (Beth, 3 days ago)
* 3ba218a - Specifying pact/latest response (Beth, 6 days ago)
* b746f23 - Changing to new /pacts/latest URL format (Beth, 6 days ago)
* 39f52cf - Working on expected 'pacts/latest' response (Beth, 6 days ago)
