# Contributing

When submitting pull request:

* **Small Contribution / Single Source Code File:** For a small change to a single source file a project committer can review and apply the change on your behalf. This is a quick workaround allowing us to correct spelling mistakes in the documentation, clarify a javadoc, or accept a very small fix.

  We understand that fixing a single source file may require changes to several test case files to verify the fix addresses its intended problem.

* **Large Contributions / Multiple Files / New Files:** To  contribute a new file, or if your change effects several files, sign a [Code Contribution License](http://docs.geoserver.org/latest/en/developer/policies/committing.html). It does not take long and you can send it via email.
   * [Corporate contributor license](https://www.osgeo.org/resources/corporate-contributor-license/)
   * [Individual contributor license](https://www.osgeo.org/resources/individual-contributor-license/)

This agreement can be printed, signed, scanned, and emailed to [info@osgeo.org](mailto:info@osgeo.org) at the Open Source Geospatial Foundation (OSGeo). [OSGeo](https://www.osgeo.org/about/)
is the non-profit which holds the GeoNode codebase for the community.

For more information, please review the section on  [submitting pull requests](http://docs.geoserver.org/latest/en/developer/policies/pull_request.html) and [making commits](http://docs.geoserver.org/latest/en/developer/policies/committing.html).

## Pull Requests

Issuing a pull request requires that you [fork the GeoNode Cloud git repository](https://github.com/Kan-T-IT/geonode-cloud) into
your own account.

Assuming that `origin` points to your GitHub repository then the workflow becomes:

1. Make the change.

```
   git checkout -b my_bugfix main
   git add .
   git commit -m "fix bug xyz"
```
2. Push the change up to your GitHub repository.
```
   git push origin my_bugfix
```
3. Visit your GitHub repository page and issue the pull request.

4. At this point the core developers will be notified of the pull request and review it at the earliest convenience. Core developers will review the patch and might require changes or improvements to it; it will be up to the contributor to amend the pull request and keep it alive until it gets merged.

> Please be patient, pull requests are often reviewed in spare time so turn-around can be a little slow. If a pull request becomes stale with no feedback from the contributor for a couple of months, it will linked to from a JIRA issue (to avoid losing the partial work) and then be closed.

## Pull Request Guidelines

The following guidelines are meant to ensure that your pull request is as easy as possible to  review.

* Ensure your IDE/editor is properly configured

  Ensure that your development environment is properly configured for GeoNode development. A common issue is a text editor is configured to use tabs rather than spaces.

* Include only relevant changes

  Ensure the patch only contains changes relevant to the issue you are trying to fix. A common mistake is  to include whitespace and formatting changes along with the relevant changes. These changes, while they  may seem harmless, make the patch much harder to read.

* Fix one thing at a time

  Do not batch up multiple unrelated changes into a single patch. If you want to fix multiple issues work on them separately and submit separate patches for them.

* Always add a test

  Given a large code base, the large number of external contributors, and the fast evolution of the code base, tests are really the only line of defense against accidental breakage of the contributed functionality. That is why we always demand to have at least one test, it's not a "punishment", but a basic guarantee your changes will still be there, and working, in future releases.

* Be patient

  The core developers review community patches in spare time. Be cognizant of this and realize that just  as you are contributing your own free time to the project, so is the developer who is reviewing and applying your patch.

* Tips

  Include a test case that shows your patch fixes an issue (or adds new functionality). If you do not include a test case the developer reviewing your work will need to create one.

## Commit Guidelines

GeoNode Cloud does not have much in the way of strict commit policies. Our current conventions are:

1. **Write meaningful commit messages**

Please take especial care of writing meaningful commit messages. 
[Here are some best practices and guidelines](https://wiki.openstack.org/wiki/GitCommitMessages#Information_in_commit_messages).

2. **Add copyright headers:**
   * Remember to add a copyright header with the year of creation to any new file. As an example, if you are adding a file in 2018 the copyright header would be:

   ```
   /* (c) 2023 Open Source Geospatial Foundation - all rights reserved
    * This code is licensed under the GPL 3.0 license, available at the root
    * application directory.
    */
   ```

   * If you are modifying an existing file that does not have a copyright header, add one as above.

   * Updates to existing files with copyright headers do not require updates to the copyright year.

   * When adding content from another organisation maintain copyright history and original license. Only add Open Source Geospatial Foundation if you have made modifications to the file for GeoNode:

   ```
   /* (c) 2016 Open Source Geospatial Foundation - all rights reserved
    * (c) 2014 OpenPlans
    * (c) 2008-2010 GeoSolutions
    *
    * This code is licensed under the GPL 2.0 license, available at the root
    * application directory.
    *
    * Original from GeoWebCache 1.5.1 under a LGPL license
    */
   ```

3. **Do not commit large amounts of binary data:** In general do not commit any binary data to the repository. There are cases where it is appropriate like some data for a test case, but in these cases the files should be kept as small as possible.

4. **Do not commit jars or libs, use Maven instead:** In general never commit a depending library directly into the repository, this is what we use Maven for. If you have a jar that is not present in any maven repositories, ask on the developer list to get it uploaded to one of the project maven repositories.

5. **Ensure code is properly formatted:** We follow the [Google formatting conventions](https://google.github.io/styleguide/javaguide.html) with the AOSP variant (4 spaces indent instead of 2).
   
   The [google-java-format project](https://github.com/google/google-java-format) offers plugins for various IDEs. If your IDE is not supported, please just build once on the command line before committing.

### Core commit access

Allows a developer to make commits to the modules of GeoNode Cloud.
Being granted this stage of access takes time, and is obtained only after the
developer has gained the trust of the other core committers.

The process of obtaining core commit access is based solely on trust.
To obtain core commit access a developer must first obtain the trust
of the other core committers.

The way this is typically done is through continuous code review of patches.
After a developer has submitted enough patches that have been met with a
positive response, and those patches require little modifications, the
developer will be nominated for core commit access.

There is no magic number of patches that make the criteria, it is based mostly
on the nature of the patches, how in depth the they are, etc... Basically it
boils down to the developer being able to show that they understand the code base
well enough to not seriously break anything.
