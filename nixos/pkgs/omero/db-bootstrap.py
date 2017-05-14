#
#
#
from argparse import ArgumentParser, ArgumentTypeError
from subprocess import Popen, PIPE, check_output, CalledProcessError
from string import Template
import sys


class Args:
    '''Command line arguments parser.'''

    def non_empty_string(self, x):
        if x is None or x.strip() == '':
            raise ArgumentTypeError("must not be empty or just white space")
        return x;

    def build_parser(self):
        p = ArgumentParser(description='OMERO database bootstrap script.')

        p.add_argument('--db-name', type=self.non_empty_string, required=True,
                       help='OMERO database name')
        p.add_argument('--db-user', type=self.non_empty_string, required=True,
                       help='OMERO database role name')
        p.add_argument('--db-pass', type=self.non_empty_string, required=True,
                       help='OMERO database role password')
        p.add_argument('--server-pass', type=self.non_empty_string, required=True,
                       help='Password for the OMERO root user (experimenter)')

        return p

    def __init__(self):
        self.parser = self.build_parser()

    def get(self):
        return self.parser.parse_args()


class PgSql:
    '''PgSql utilities.'''

    # Single quote escaping in Postgres: two single quotes.
    @staticmethod
    def escape_single_quote(x):
        return x.replace("'", "''")

    # Double quote escaping in Postgres: two double quotes.
    @staticmethod
    def escape_double_quote(x):
        return x.replace('"', '""')

    @staticmethod
    def to_string(x):
        escaped = PgSql.escape_single_quote(x)
        return "'{0}'".format(escaped)

    @staticmethod
    def to_quoted_identifier(x):
        escaped = PgSql.escape_double_quote(x)
        return '"{0}"'.format(escaped)


class CreateDb:
    '''Produces the SLQ to create the OMERO database and role.'''

    sqlTemplate = Template('''
CREATE ROLE ${db_user}
       LOGIN PASSWORD ${db_pass};

CREATE DATABASE ${db_name}
       OWNER ${db_user}
       ENCODING 'UTF8';
''')

    @staticmethod
    def sql(db_name, db_user, db_pass):
        return CreateDb.sqlTemplate.substitute(
            db_name = PgSql.to_quoted_identifier(db_name),
            db_user = PgSql.to_quoted_identifier(db_user),
            db_pass = PgSql.to_string(db_pass)
        )


class Psql:
    '''Uses the psql command to execute SQL statements.'''

    def __init__(self, options=None):
        if options is None:
            options = []
        self.cmd = ['cat'] + options # ['psql'] + options

    def check_outcome(self, status, out, err):
        if status != 0:
            sys.stderr.write(err)
            raise CalledProcessError(cmd=self.cmd, returncode=status)
        return out

    def run_sql(self, sql):
        psql = Popen(self.cmd, stdin=PIPE, stdout=PIPE, stderr=PIPE)
        out, err = psql.communicate(input=sql)
        return self.check_outcome(psql.returncode, out, err)

    def pipe_sql(self, producer_cmd):
        producer = Popen(producer_cmd, stdout=PIPE)
        psql = Popen(self.cmd, stdin=producer.stdout, stdout=PIPE)
        producer.stdout.close()  # Allow producer to receive a SIGPIPE if psql exits.
        out, err = psql.communicate()
        return self.check_outcome(psql.returncode, out, err)

    def db_exists(self, db_name):
        # see http://stackoverflow.com/questions/14549270/check-if-database-exists-in-postgresql-using-shell
        out = check_output(self.cmd + ['-ltq'])
        # now need to parse out tho, a better option could be to run a
        # SELECT datname FROM pg_database
        # see: https://www.postgresql.org/docs/current/static/catalog-pg-database.html

#if __name__ == "__main__":
#    args = Args().get()
#    print("DB NAME: %s" % args.db_name)
