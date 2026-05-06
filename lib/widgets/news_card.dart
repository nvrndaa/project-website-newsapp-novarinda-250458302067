import 'package:flutter/material.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  const NewsCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: AppColors.cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: AppColors.divider,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: AppColors.divider,
                  child: Center(child: Icon(Icons.broken_image, color: AppColors.textHint)),
                ),

              ),
            ),
            Padding(padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (article.source?.name != null) ...{
                      Expanded(child: 
                      Text(article.source!.name,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                      )
                      ),
                      SizedBox(width: 8.0,)
                    },
                    if (article.publishedAt != null)
                    Text(
                      timeago.format(DateTime.parse(article.publishedAt!)),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    
                  ],
                ),
                SizedBox(height: 8,),
                    if (article.title != null)
                    Text(article.title!,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      ),
                    SizedBox(height: 8,),
                    if (article.description != null)
                    Text(article.description!,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      )
              ],
            ),
            )
          ],
        ),
      )
    );
  }
}