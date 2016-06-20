Do this to generate your change history

    $ git log --pretty=format:'  * %h - %s (%an, %ad)' vX.Y.Z..HEAD

#### 1.0.2 (2016-06-20)

* 4637978 - Warn on overwritting (Taiki Ono, Mon Jun 6 14:50:37 2016 +0900)

#### 1.0.1 (2016-04-29)

* 72c099b - Add release instructions (Sergei Matheson, Fri Apr 29 11:54:01 2016 +1000)
* 12f0054 - :headers is duplicated and overwritten (Taiki Ono, Tue Mar 15 21:46:23 2016 +0900)
* e9251f7 - Commit pact files (Taiki Ono, Tue Mar 15 21:30:15 2016 +0900)
* 0278731 - Loosen content type header expectation (Taiki Ono, Tue Mar 15 21:26:03 2016 +0900)
* fff1838 - Remove `Gemfile.lock` and do not check-in (Taiki Ono, Sun Mar 13 21:49:36 2016 +0900)
* 48c1434 - Add Travis CI setting not to test with ruby1.9 (Taiki Ono, Sun Mar 13 21:17:11 2016 +0900)
* 0365b94 - Updated to RSpec 3 syntax (Beth, Mon Oct 19 08:54:48 2015 +1100)

#### 1.0.0 (2014-10-09)

* 2c08da2 - added pact_broker_basic_auth options to publish task (lifei zhou, Fri Feb 27 21:33:09 2015 +1100)
* 1b84a54 - Updated pact-version rel name (Beth, Mon Dec 22 11:30:57 2014 +1100)
* 04c1e4e - Updated link rels (Beth, Thu Dec 11 14:32:27 2014 +1100)
* d1b2cad - Correcting pact publish message (Beth Skurrie, Mon Aug 25 07:15:57 2014 +1000)
* 6b1d147 - Added backwards compatibility for pact broker publish response (Beth Skurrie, Sun Aug 24 17:50:16 2014 +1000)
* 8c8aa89 - Added location of latest pact to output of pact:publish (Beth Skurrie, Sun Aug 24 17:43:02 2014 +1000)
* e6b56d0 - Added retries for pact publishing (Beth Skurrie, Sun Aug 24 16:55:10 2014 +1000)
* 27c00e5 - Disabled pacticipant version interactions, not needed yet. (Beth Skurrie, Sat May 17 17:57:33 2014 +1000)
* cfefdc4 - Changed path from /pact to /pacts (Beth Skurrie, Sat May 17 15:58:32 2014 +1000)

#### 0.0.6 (2014-03-24)

* 2ad5f7d - Updated method of tagging versions (bethesque, Sat Mar 22 16:54:37 2014 +1100)
* b74128f - Added 'latest' pact url to pact representation in the 'latest pacts' response (bethesque, Sat Mar 22 09:04:31 2014 +1100)

#### 0.0.5 (2014-01-03)

* 194183c - Removing debugger for Travis CI (bethesque, Fri Jan 3 12:45:07 2014 +1100)
* b42aba9 - Changed 'last' to 'latest' (bethesque, Tue Nov 19 09:30:12 2013 +1100)
* 30d63b7 - Changed name to title in list pacticipants response (bethesque, Mon Nov 18 09:37:11 2013 +1100)

#### 0.0.4 (2013-11-15)

* cf33479 - Merge branch 'master' of github.com:bethesque/pact_broker-client (Beth, 20 hours ago)
* 01087ae - Fixed problem where PublicationTask block was evaluated at load time, instead of run time. (Beth, 20 hours ago)
* 2073234 - Updating to use example.org as the base URL (Beth, 2 days ago)
* 07073de - Updating latest pact URL (Beth, 2 days ago)

#### 0.0.3 (2013-11-13)

* a3488bd - Fixing application/json+hal to application/hal+json (Beth, 2 days ago)
* 0fa89ef - Updating content type to match new Webmachine implementation. Removing redundant repository_url interaction. (Beth, 2 days ago)
* 9e1539e - Redoing the URLs yet again (Beth, 3 days ago)
* 9067b83 - Working on list latest pacts (Beth, 3 days ago)
* 3ba218a - Specifying pact/latest response (Beth, 6 days ago)
* b746f23 - Changing to new /pacts/latest URL format (Beth, 6 days ago)
* 39f52cf - Working on expected 'pacts/latest' response (Beth, 6 days ago)
