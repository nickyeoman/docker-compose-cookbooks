################################################################################
# use like this: python3 run.py > test.sql
# TODO: you need to change the last comma to a semi colon for it to work in mysql
# php artisan bookstack:regenerate-permissions
################################################################################

import os
import html
directory = '/home/nick/working/emails-202003'

# The insert statement to insert a page
print("INSERT INTO `pages` (`id`, `book_id`, `chapter_id`, `name`, `slug`, `html`, `text`, `priority`, `created_at`, `updated_at`, `created_by`, `updated_by`, `restricted`, `draft`, `markdown`, `revision_count`, `template`) VALUES" )

os.chdir(directory)

for filename in os.listdir(directory):

    if filename.endswith(".txt"):
        f = open(filename)

        #print filename
        #print(filename)

        #print filenmae with no extension
        base=os.path.basename(filename)
        filenoext=os.path.splitext(base)
        filenoext=str(filenoext[0])
        #print(filenoext[0])

        # print file contents html safe
        lines = f.read()
        htmlcontentdirty=str(html.escape(lines))
        htmlcontentspaces=htmlcontentdirty.replace('\r', '<br />').replace('\n', '<br />')
        htmlcontent=' '.join(htmlcontentspaces.split())

        #generate slug
        slugnospace=str(filenoext).replace(" ", "_")
        slug=slugnospace.lower()

        # now write the sql query
        print("(NULL, '1', '33', '", end = '')
        print(filenoext, end = '') #Name
        print("', '", end = '')
        print(slug, end = '') #slug
        print("', '", end = '')
        print(htmlcontent, end = '')
        print("', 'text_var', '0', NOW(), NOW(), '1', '1', '0', '0', 'markdown_var', '0', '0'),")

        continue
    else:
        continue
