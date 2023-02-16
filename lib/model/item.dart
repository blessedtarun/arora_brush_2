      import 'package:cloud_firestore/cloud_firestore.dart';

      class ItemModel {
        String category;
        String details;
        int discount;
        bool isFeatured;
        String longDescription;
        int mrp;
        String pid;
        int price;
        Timestamp publishedDate;
        int quantity;
        String shortInfo;
        String status;
        List thumbnailUrl;
        String title;

        ItemModel({
          this.title,
          this.shortInfo,
          this.publishedDate,
          this.thumbnailUrl,
          this.longDescription,
          this.status,
        });

        ItemModel.fromJson(Map<String, dynamic> json) {
          category = json['category'];
          details = json['details'];
          discount = json['discount'];
          isFeatured=json['isFeatured'];
          longDescription = json['longDescription'];
          mrp = json['mrp'];
          pid = json['pid'];
          price = json['price'];
          publishedDate = json['publishedDate'];
          quantity = int.parse(json['quantity']);
          shortInfo = json['shortInfo'];
          status = json['status'];
          thumbnailUrl = json['thumbnailUrl'];
          title = json['title'];
          
        }

        Map<String, dynamic> toJson() {
          final Map<String, dynamic> data = new Map<String, dynamic>();
          data['title'] = this.title;
          data['shortInfo'] = this.shortInfo;
          data['price'] = this.price;
          if (this.publishedDate != null) {
            data['publishedDate'] = this.publishedDate;
          }
          data['thumbnailUrl'] = this.thumbnailUrl;
          data['longDescription'] = this.longDescription;
          data['status'] = this.status;
          data['details'] = this.details;
          return data;
        }
      }

      class PublishedDate {
        String date;

        PublishedDate({this.date});

        PublishedDate.fromJson(Map<String, dynamic> json) {
          date = json['$date'];
        }

        Map<String, dynamic> toJson() {
          final Map<String, dynamic> data = new Map<String, dynamic>();
          data['$date'] = this.date;
          return data;
        }
      }
