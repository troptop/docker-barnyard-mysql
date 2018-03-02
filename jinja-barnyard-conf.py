#!/usr/bin/python


from jinja2 import Environment, FileSystemLoader
import os

# Capture our current directory
THIS_DIR = os.path.dirname(os.path.abspath(__file__))

def print_html_doc():
    # Create the jinja2 environment.
    # Notice the use of trim_blocks, which greatly helps control whitespace.
    j2_env = Environment(loader=FileSystemLoader(THIS_DIR),
                         trim_blocks=True)
    print j2_env.get_template('barnyard-conf.template').render(
        dbhost=os.getenv('MYSQL_HOST'),dbuser=os.getenv('MYSQL_USER'),
	dbpass=os.getenv('MYSQL_PASSWORD'),dbname=os.getenv('MYSQL_DBNAME'),
        dbtype=os.getenv('MYSQL_OUTPUT_TYPE')

    )

if __name__ == '__main__':
    print_html_doc()

