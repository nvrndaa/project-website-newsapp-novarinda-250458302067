import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Article article = Get.arguments as Article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null
              ? CachedNetworkImage(imageUrl: article.urlToImage!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.divider,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.divider,
                child: Icon(Icons.broken_image,
                color: AppColors.textHint,
                ),
              ),
              )
              : Container(
                color: AppColors.divider,
                child: Icon(
                  Icons.broken_image,
                  color: AppColors.textHint,
                ),
              )
            ),
            actions: [
              IconButton(onPressed: () => _shareArticle(), icon: Icon(Icons.share)),
              PopupMenuButton(
                onSelected: (Value){
                  switch(Value){
                    case'copy_link':
                    _copyLink();
                    break;
                    case 'open_browser':
                    _openInBrowser();
                    break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8,),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser),
                        SizedBox(width: 8,),
                        Text('Open In Browser'),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          article.source!.name,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12,)
                    ],
                    if (article.publishedAt != null)...[
                    Text(
                      timeago.format(DateTime.parse(article.publishedAt!)),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      )
                    )
                    ],
                    ],
                  ),
                  SizedBox(height: 16,),
                  if(article.title != null)...[
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 16,),
                  ],
                  if(article.description != null)...[
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16,),
                  ],
                  if(article.content != null)...[
                    Text(
                      'content',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      article.content!,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16,),
                  ],
                  if (article.url != null)...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: _openInBrowser,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                       child: Text('Read Full Article')
                       ),
                    )
                  ]
                ], 
              ),
            ),
          )
        ],
      ),
    );
  }

  void  _openInBrowser() async {
    if (article.url != null){
      final Uri url = Uri.parse(article.url!);
      if(await canLaunchUrl(url)){
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }else{
        Get.snackbar(
          'Error',
           'Could not open the link',
           snackPosition: SnackPosition.BOTTOM,
           );
      }
    }
  }

  void _shareArticle (){
    if (article.url != null){
      Share.share(
        '${article.title ?? 'Check out this article'}\n\n${article.url}',
        subject: article.title ?? 'News Article',
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'link copied',
        'Article URL has been copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }
}