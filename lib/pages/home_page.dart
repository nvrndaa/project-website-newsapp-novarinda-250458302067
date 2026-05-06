import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:news_app/widgets/news_card.dart';

class HomePage extends GetView<NewsController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        centerTitle: true,
        actions: [IconButton(onPressed: () => _showSearchDialog(context), icon: Icon(Icons.search))],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                //obx = widget dari get x yang UI auto update kalau state nya berubah
                return Obx(
                  () => CategoryChip(
                    label: category.capitalize ?? category,
                    isSelected: controller.selectedCategory == category,
                    onTap: () => controller.selectCategory(category),
                  ),
                );
              },
            ),
          ),
          Expanded(
            // obs itu widget dari get x 
            // yang fungsinya buat bikin UI auto update kalo state yang berubah,
            // jadi kita bisa pantau isLoading, error, sama articles nya di news controller
            child: Obx(() {
              if (controller.isLoading) {
                return LoadingShimmer();
              }

              if (controller.error.isNotEmpty) {
                return _buildErrorWidget();
              }

              if (controller.articles.isEmpty) {
                return _buildEmptyWidget();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return NewsCard(article: article, onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: article));
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshNews,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog (BuildContext context){
    final TextEditingController searchController = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Search News'),
      content: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Enter search keyword',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty){
            controller.searchNews(value);
            Navigator.of(context).pop();
          }
        }
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
           child: Text('Cancle'),
        ),
        ElevatedButton(child: Text('Search'), onPressed: (){
          if (searchController.text.isNotEmpty){
            controller.searchNews(searchController.text);
                Navigator.of(context).pop();
          }
        })
      ],
    )
   );
  }
}