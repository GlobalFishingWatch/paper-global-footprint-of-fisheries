
# coding: utf-8

# # Update Table Documentation
# 
# This file takes the docs in the folder `data_documentation` and adds them to bigquery and to gcs. The markdown file in `data_documentation` must have the same name as the file in bigquery at `global-fishing-watch:global-footprint-of-fisheries.TABLE_NAME`. Also, the markdown file must have the table schema formatted at the end of the file with markdown bullet points, as follows:
# 
# ```
# # Table Schema
#  - field_1: 
#  - field_2: lots
#  of stuff about field 2
#    - you can make a list of items for field 2
#    - if you indent them
#  - field_3: it is important to have the :
#  
#  this will also be in field 3
#  
#  - field_4: this is in the 4th field
# ```

# In[5]:


import os
import json
from subprocess import check_output
import sys


# In[19]:


def de_markdownify(text):
    '''this gets rid of # characters, and also [ and ]. Can be improved'''
    return text.replace("# ","").replace("#","").replace("[","").replace("]"," ")

def push_readme_to_gcs(table):
    with open("{}.md".format(table),'rU') as f:
        lines = f.read()
    # getting rid of the "#", and other formatting, and push to gcs
    lines2 = de_markdownify(lines)
    with open("temp.txt", 'w') as f:
        f.write(lines2)    
    command = 'gsutil cp temp.txt gs://global_footprint_of_fisheries/{}/readme.txt'.format(table)
    os.system(command)
    os.system("rm temp.txt")

def add_documentation_to_bigquery(table):
    
    '''this takes a markdown file at TABLE_NAME.md and loads
    it into a bigquery table, with the same name, at '''
    
    with open("{}.md".format(table),'rU') as f:
        lines = f.read()
    # getting rid of the "#", and other formatting, and push to gcs
    lines = de_markdownify(lines)
    
    # this assumes that the file is divided into a line that equals Schema\n
    table_description = lines.split("\nTable Schema\n")[0]
    table_schema = lines.split("\nTable Schema\n")[1]
    # add description
    table_description = table_description.replace("'","'\\''").replace('"',"""'\\"'""") # so the command works
    command = '''bq update --description '{table_description}'     global-fishing-watch:global_footprint_of_fisheries.{table}'''.format(table_description=table_description,
                                                                         table=table)
    os.system(command)
    
    # add schema
    add_schema(table, table_schema)

    
def add_schema(table, table_schema):
    '''takes a table, and a table_schema which is written as a list in markdown, and loads 
    the values into the table on bigquery. The fields in the list have to match perfectly with 
    the fields in the existing bigquery table, or this will fail.'''
    descriptions = {}

    for line in table_schema[3:].split("\n - "):
        if(":" in line): 
            k = line.split(":")[0]
            value = "".join(line.split(":")[1:])
            descriptions[k]=value
    
    # Get the existing bigquery schema
    command = "bq show --format=json global-fishing-watch:global_footprint_of_fisheries.{table}".format(table=table)
    out = check_output(command.split(" "))

    # update the schema structure to include a description from the markdown file
    j = json.loads(out)
    for i, s in enumerate(j['schema']['fields']):
        d = descriptions[s['name']]
        j['schema']['fields'][i]['description'] = d

    # load this new schema into bigquery
    with open('temp.json','w') as f:
        f.write(json.dumps(j['schema']['fields']))
    command = "bq update global-fishing-watch:global_footprint_of_fisheries.{table} temp.json".format(table=table)
    os.system(command)
    os.system("rm -f temp.json")


# Run this over all the markdown files in this folder


from os import listdir
from os.path import isfile, join
onlyfiles = [f for f in listdir("./") if isfile(join("./", f))]
for o in onlyfiles:
    if len(o)>3 and o[-3:] == ".md": 
        table = o[:-3]
        add_documentation_to_bigquery(table)       
        push_readme_to_gcs(table)

