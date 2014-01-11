---
layout: post
date: 2008-12
title: Migrating live website
---

I will describe the migration strategy I used to move the live website from the old server to the new one.

Old website configuration:

* Windows 2000 Server
* MSSQL 2000
* ASP, ASP.NET1.1, PHP5

It was a virtual hosting with all its drawbacks - shared MS SQLServer 2000, no RDP, no way to install ISAPI modules or even additional scripting languages (or change their configuration), no proper control over the email server, no ability to set custom backup scheme and so on and so on. It's obvious that when a website starts to be much more than just a set of a static informational pages but rather a full-blown complicated web-app, it needs better and more controlled infrastructure.

So we wanted our server fully managed by professional hosters, we wanted it sitting behind a properly configured firewall in the reliable datacentre but still under our full control.

That's why we decided to go for a dedicated server hosted at <a href="http://www.ukfast.net/">UKFAST</a> in their datacentre in Manchester. I've been to this datacenter, and I can tell you - it was really exciting :)

But due to the fact that our website is used 24 hours a day we had to find a way to move it along with the SSL certificate, mail server and the database causing as less interruption to the live site work as possible.

# Phase 0: preparing the infrastructure
During this stage we made sure that changing addresses of the resources web-apps used was just a matter of changing one-two lines in the global configuration files (e.g. SQL Server name, mail server name). We also configured all the services on the new dedicated hosting to have the same settings/user logins etc; uploaded web-apps scripts and checked that they worked correctly. 

To get everything tested properly, we temprorarily added a line to **%systemroot%\system32\hosts** files to make our computers think that the domain name was bound to the new dedicated server IP address. Found errors were fixed, required modules were installed and configured. As emails that our web-apps send were still being sent through the old virtual hosting mail server and all data was still stored on the old virtual hosting SQL Server, we didn't have to modify anything in the code of our web applications, we just made sure that there were no errors and the new server infrastructure was ready for the website migration.

I estimated this phase to take 3 days, but it actually took 2 working days.

# Phase 1: preparing for moving the domain name
With our dedicated server package we've got full control over two DNS servers, so the first step was to create four DNS records:

* A record for ourdomain.co.uk pointing to the new server IP address

* A record for <a href="http://www.ourdomain.co.uk" rel="nofollow">http://www.ourdomain.co.uk</a> pointing to the new server IP address

* A record for mail.ourdomain.co.uk pointing to the old mail server IP address

Then DNS propagation period kicked in - during ~48 hours (TTL for **.co.uk** TLD is 172800 seconds) all the DNS servers in the world were copying the information.

This phase took us an hour.

# Phase 2: preparing to move the data

As we had to wait at least 48 hours before we could change the **NS records** for our domain name, we took our time to prepare a migration plan for the SQL server data. As we had users committing data to our SQL server all the time, we decided that the only possible way to migrate the server was at night.

The simplest way to move data from one SQL Server to another is to do a full backup on the old server and restore it on the new one. We measured that backup-upload-restore sequence took up to 2 hours, so we decided to down the website for two hours on a Friday night to move the SSL key and SQL Server data.

This phase had been estimated as 4 hours task and it took exactly 4 :)

# Phase 3: moving the SQL Server data

On one Friday night we stopped clients from commiting data to the old SQL server and moved the data. Here's the procedure we followed:

1. We created a custom error page with the &ldquo;maintenance&rdquo; message on the old server

2. changed SQL connection strings on the old server webapps configuration files to point to an inexistant SQL Server address, so if any client tried to write data to the SQL server, he was shown the custom error page

3. did a backup of the data, uploaded it to the new dedicated server and ran the import

4. changed SQL connection strings in the configuration files on the _new server_ to point to the new SQL server

5. changed SQL connection strings in the configuration files on the _old server_ to point to the new SQL server, so all the clients coming to the old site would still get their data saved to the new SQL Server

6. disable HTTPS on the old server

7. exported SSL key from the old server, uploaded and imported to the new one

This phase took us 3 hours. While the third task was in progress clients could't place an order or post a message on the forum. This third task took nearly two hours but as soon as it was finished and task 4 and 5 were done, normal work of the website was restored and clients could save data and it was committed to the new SQL Server, so actual downtime was ~2 hours due to SQL data transfer process.

Also during this step we disabled HTTPS on the old webserver and moved the SSL key to the new one.

# Phase 4: final steps

To summarise the state at the time when Phase 3 is completed:

Old host has the following configuration:

* DNS servers have the following records:

	* A record for ourdomain.co.uk pointing to the IP address of the old webserver

	* A record for <a href="http://www.ourdomain.co.uk" rel="nofollow">http://www.ourdomain.co.uk</a> pointing to the IP address of the old webserver

	* A record for mail.ourdomain.co.uk pointing to the IP address of the old mail server

	* MX record for mail.ourdomain.co.uk

* SQL connection strings in the configuration files point to the new SQL server so data gets saved there

* mail is sent through mail.ourdomain.co.uk which according to the DNS settings on all the DNS servers point to the IP address of the old mail server

* https is disabled

And the new host:

* DNS servers have the following records:

	* A record for ourdomain.co.uk pointing to the IP address of the new webserver

	* A record for <a href="http://www.ourdomain.co.uk" rel="nofollow">http://www.ourdomain.co.uk</a> pointing to the IP address of the new webserver

	* A record for mail.ourdomain.co.uk pointing to the IP address of the old mail server

	* MX record for mail.ourdomain.co.uk

* SQL connection strings in the configuration files point to the new SQL server

* mail is sent through mail.ourdomain.co.uk i.e. through the old mail server

* https is enabled and uses the imported certificate for our domain name


On this step we changed NS records for our domain name to be the new DNS servers. During next 48 hours DNS changes were propagating throughout the world and we were noticing as clients were starting to visit our new webserver. Wherever a client came to, his data was stored in the new SQL Server and emails were sent through the old mail server; but only if he came to the new webserver, he could use HTTPS.

Then we started Exchange integration process which I'm going to cover in one of the next posts.

# Summary

We tried to have as less downtime as possible and we achieved the goal without any additional investments.

During the process we had complete downtime (when clients couldn't put orders) only of 2 hours during the SQL migration and up to 48 hours when HTTPS was disabled on the old server (but for the UK clients DNS propagation took less than a day - we changed NS records on Friday night and had first clients coming to the new webserver on Saturday morning!).

Actually we could migrate the website without any downtime at all and that would require two additional steps:

* Obtain a separate SSL license for Load Balancing, this would allow us not to have any HTTPS downtime - the certificate for our domain name would be installed on both servers. But this means that we would lose the money we paid for this license as soon as the migration process is finished.

* Set MSSQL mirroring so that both SQL servers synchronise transparently, in which case we wouldn't have a downtime of two hours when clients could't place orders. This wasn't possible with our old virtual hosting.