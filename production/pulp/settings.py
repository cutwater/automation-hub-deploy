import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('PULP_DB_NAME', 'pulp'),
        'USER': os.environ.get('PULP_DB_USER', 'pulp'),
        'PASSWORD': os.environ.get('PULP_DB_PASSWORD', ''),
        'HOST': os.environ.get('PULP_DB_HOST', 'localhost'),
        'PORT': os.environ.get('PULP_DB_PORT', ''),
    }
}

CONTENT_PATH_PREFIX = '/api/automation-hub/v3/artifacts/collections/'

ANSIBLE_API_HOSTNAME = ''

MEDIA_ROOT = '/data/'

GALAXY_API_ROOT = 'api/<str:path>/'

DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
AWS_STORAGE_BUCKET_NAME = os.environ['PULP_AWS_STORAGE_BUCKET_NAME']
AWS_ACCESS_KEY_ID = os.environ['PULP_AWS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['PULP_AWS_ACCESS_KEY']
AWS_S3_REGION_NAME = os.environ.get('PULP_AWS_S3_REGION_NAME')
AWS_DEFAULT_ACL = None
