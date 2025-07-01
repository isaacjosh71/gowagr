import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../core/constant/app_colors.dart';
import '../../data/model/event_model.dart';

class EventCard extends StatelessWidget {
  final TabListRes event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
           children: [
             ClipRRect(
               borderRadius: BorderRadius.all(Radius.circular(1000)),
               child: CachedNetworkImage(
                 imageUrl: event.image128Url,
                 height: 48,
                 width: 48,
                 fit: BoxFit.cover,
                 placeholder: (context, url) => Container(
                   height: 48, width: 48,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(1000),
                     color: AppColors.background,
                   ),
                   child: Center(
                     child: CircularProgressIndicator(
                       valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                     ),
                   ),
                 ),
                 errorWidget: (context, url, error) => Container(
                   height: 48, width: 48,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(1000),
                     color: AppColors.background,
                   ),
                   child: Center(
                     child: Icon(
                       Icons.image_not_supported,
                       color: AppColors.textSecondary,
                       size: 48,
                     ),
                   ),
                 ),
               ),
             ),
             SizedBox(width: 10),
             SizedBox(
               width: 230,
               child: Text(
                 event.title,
                 style: TextStyle(
                   color: AppColors.text,
                   fontSize: 14,
                   fontWeight: FontWeight.w700,
                   height: 1.3,
                 ),
                 maxLines: 2,
                 overflow: TextOverflow.ellipsis,
               ),
             ),
           ],
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: event.markets.take(1).length,
              itemBuilder: (context, index) {
                final market = event.markets.first;
                return  Row(
                  children: [
                    Container(
                      height: 45, width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: 'Buy Yes - ',
                                style: TextStyle(color: AppColors.primary),
                              ),
                              TextSpan(
                                text: '₦${market.yesPriceForEstimate}',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    Container(
                      height: 45, width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.error.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: 'Buy No - ',
                                style: TextStyle(color: AppColors.error),
                              ),
                              TextSpan(
                                text: '₦${market.noPriceForEstimate}',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                ;
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text('${event.totalVolume} Tracks',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Ends ${DateFormat('MMM dd, yyyy').format(event.resolutionDate)}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

}