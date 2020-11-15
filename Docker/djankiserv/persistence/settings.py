# -*- coding: utf-8 -*-

import os
import socket
from pathlib import Path

import djankiserv.unki
from djankiserv.unki.database import MariadbAnkiDataModel, PostgresAnkiDataModel

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve(strict=True).parent.parent

SECRET_KEY = os.getenv("DJANKISERV_SECRET_KEY", "a_very_secretive_key")

ALLOWED_HOSTS = os.getenv("DJANKISERV_ALLOWED_HOSTS", "localhost,127.0.0.1").split(",")
ALLOWED_HOSTS += [socket.gethostbyname(socket.gethostname())]  # for kubernetes probes

INSTALLED_APPS = [
    # core
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # community
    "rest_framework",
    "django_k8s",  # allows for a more elegant init-container to check for migrations and db availability
    # local
    "djankiserv.apps.DjankiservConfig",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "mysite.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "mysite.wsgi.application"

DATABASES = {}

if os.getenv("DJANKISERV_MAINDB_ENGINE") == "django.db.backends.mysql":
    DATABASES["default"] = {
        "ENGINE": os.getenv("DJANKISERV_MAINDB_ENGINE", "django.db.backends.mysql"),
        "NAME": os.getenv("DJANKISERV_MAINDB_NAME", "djankiserv"),
        "USER": os.getenv("DJANKISERV_MAINDB_USER", "djankiserv"),
        "PASSWORD": os.getenv("DJANKISERV_MAINDB_PASSWORD", "password"),
        "HOST": os.getenv("DJANKISERV_MAINDB_HOST", "127.0.0.1"),
        "OPTIONS": {"autocommit": True, "init_command": "SET default_storage_engine=INNODB"},
        "PORT": os.getenv("DJANKISERV_MAINDB_PORT", "3306"),
    }
else:
    DATABASES["default"] = {
        "ENGINE": os.getenv("DJANKISERV_MAINDB_ENGINE", "django.db.backends.postgresql"),
        "NAME": os.getenv("DJANKISERV_MAINDB_NAME", "djankiserv"),
        "USER": os.getenv("DJANKISERV_MAINDB_USER", "djankiserv"),
        "PASSWORD": os.getenv("DJANKISERV_MAINDB_PASSWORD", "password"),
        "HOST": os.getenv("DJANKISERV_MAINDB_HOST", "127.0.0.1"),
        "PORT": os.getenv("DJANKISERV_MAINDB_PORT", "5432"),
    }

if os.getenv("DJANKISERV_USERDB_ENGINE") == "django.db.backends.mysql":
    djankiserv.unki.AnkiDataModel = MariadbAnkiDataModel
    DATABASES["userdata"] = {
        "ENGINE": os.getenv("DJANKISERV_USERDB_ENGINE", "django.db.backends.mysql"),
        "NAME": os.getenv("DJANKISERV_USERDB_NAME", "djankiserv"),
        "USER": os.getenv("DJANKISERV_USERDB_USER", "djankiserv"),
        "PASSWORD": os.getenv("DJANKISERV_USERDB_PASSWORD", "password"),
        "HOST": os.getenv("DJANKISERV_USERDB_HOST", "127.0.0.1"),
        "OPTIONS": {
            "autocommit": True,
            "init_command": "SET default_storage_engine=INNODB",
            "sql_mode": "traditional,NO_BACKSLASH_ESCAPES",
        },
        "PORT": os.getenv("DJANKISERV_USERDB_PORT", "3306"),
    }
else:
    djankiserv.unki.AnkiDataModel = PostgresAnkiDataModel
    DATABASES["userdata"] = {
        "ENGINE": os.getenv("DJANKISERV_USERDB_ENGINE", "django.db.backends.postgresql"),
        "NAME": os.getenv("DJANKISERV_USERDB_NAME", "djankiserv"),
        "USER": os.getenv("DJANKISERV_USERDB_USER", "djankiserv"),
        "PASSWORD": os.getenv("DJANKISERV_USERDB_PASSWORD", "password"),
        "HOST": os.getenv("DJANKISERV_USERDB_HOST", "127.0.0.1"),
        "PORT": os.getenv("DJANKISERV_USERDB_PORT", "5432"),
    }

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# You can remove the AUTHENTICATION_CLASSES that you don't want to support, or keep them all
REST_FRAMEWORK = {  # this better protects the /api/* methods, the xSYNC methods have 'AllowAll' decorators
    "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.IsAuthenticated"],
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_simplejwt.authentication.JWTAuthentication",
        "rest_framework.authentication.BasicAuthentication",
        "rest_framework.authentication.SessionAuthentication",
    ],
}

LANGUAGE_CODE = "en-gb"
TIME_ZONE = "UTC"
USE_I18N = True
USE_L10N = True
USE_TZ = True

STATIC_URL = "/static/"

# Djankiserv values

# if you change this, it must also be changed in the images/static/Dockerfile
STATIC_ROOT = "build/static"

# This is required as Django will add a slash and redirect to that by default, and our clients don't
# support that
APPEND_SLASH = False

DJANKISERV_SYNC_URLBASE = "sync/"  # this is not actually currently configurable, due to hardcoding in the clients
DJANKISERV_SYNC_MEDIA_URLBASE = "msync/"  # this is not actually configurable, due to hardcoding in the clients
DJANKISERV_API_URLBASE = "dapi/"

DJANKISERV_DATA_ROOT = os.getenv("DJANKISERV_DATA_ROOT", "/tmp")

# DEBUG STUFF
DJANKISERV_DEBUG = os.getenv("DJANKISERV_DEBUG", "False").lower() == "true"
DEBUG = DJANKISERV_DEBUG  # currently the same

DJANKISERV_GENERATE_TEST_ASSETS = False
DJANKISERV_GENERATE_TEST_ASSETS_DIR = "/tmp/asrv/"
