from django.db import models

# Create your models here.
class Image(models.Model):
    '''
    '''
    
#    image_loc = models.CharField(max_length=300) 
    image = models.ImageField(upload_to = 'image/%Y/%m/%d')
    image_name = models.CharField(max_length=800)
    location_descriptor = models.CharField(max_length=800)
    timestamp = models.DateTimeField(auto_now=True)
    
    class Meta:
        get_latest_by = 'timestamp'
    
class FindObjectTest(models.Model):
    '''
    '''
        
    x_coord = models.IntegerField()
    y_coord = models.IntegerField()
    relaxed = models.NullBooleanField()
    image_name = models.CharField(max_length=800)
    object_name = models.CharField(max_length=800)
    timestamp = models.DateTimeField(auto_now=True)
    
    class Meta:
        get_latest_by = 'timestamp'
    
class Object(models.Model):
    '''
    '''

    object_name = models.CharField(max_length=800)
    object_thumbnail = models.ImageField(upload_to = 'object_image/%Y/%m/%d')
    timestamp = models.DateTimeField(auto_now=True)
    
    class Meta:
        get_latest_by = 'timestamp'
    
    