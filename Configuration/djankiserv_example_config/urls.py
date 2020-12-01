# -*- coding: utf-8 -*-

from django.contrib import admin
from django.urls import include, path
from django.views.generic.base import RedirectView

from . import views

urlpatterns = [
    path("", RedirectView.as_view(url="/admin/")),
    path("djs/", include("djankiserv.urls")),
    path("health", views.health),
    path("admin/", admin.site.urls),
]
