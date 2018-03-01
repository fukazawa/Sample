from django.db import models

class Stocks(models.Model):
    id = models.IntegerField(primary_key=True)
    name = models.CharField(max_length=128)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'stocks'

