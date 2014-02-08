# -*- coding: utf-8 -*-
"""
Created on Sat Feb  8 09:33:00 2014

@author: laegrim
"""

from turk.models import FindObjectTest, Image, Object
from django.contrib import admin
from django.contrib.auth.models import User

admin.site.register(FindObjectTest)
admin.site.register(Object)
admin.site.register(Image)
