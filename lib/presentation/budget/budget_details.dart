import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/utils/dateTimeForamtUtil.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/budget/BudgetItem.dart';
import '../../data/model/budget/budget_post_model.dart';
import '../tenant_complain_list/complain_pending_list_screen.dart';
import 'blocs/get_budget_cubit.dart';
import 'blocs/get_budget_state.dart';
import 'blocs/post_budget_cubit.dart';
import 'blocs/post_budget_state.dart';

class EstimatedBudgetScreen extends StatefulWidget {
  final ComplainEntity complain; // Add complainID parameter

  const EstimatedBudgetScreen({
    super.key,
    required this.complain,
  });

  @override
  State<EstimatedBudgetScreen> createState() => _EstimatedBudgetScreenState();
}

class _EstimatedBudgetScreenState extends State<EstimatedBudgetScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch budget items when screen initializes
    context.read<GetBudgetCubit>().fetchBudget(complainID: widget.complain.complainID);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final currencyFormat = NumberFormat.currency(symbol: '৳', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Estimated Budget",
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: SafeArea(
        child: BlocBuilder<GetBudgetCubit, GetBudgetState>(
          builder: (context, state) {
            if (state is GetBudgetLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetBudgetFailureState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorMessage),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<GetBudgetCubit>().fetchBudget(
                        complainID: widget.complain.complainID,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is GetBudgetSuccessState) {
              final items = state.budgetItems;
              final totalBudget = items.fold<double>(
                  0.0, (sum, item) => sum + (item.total.toDouble()));

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //complain details
                    ComplainDetailsCard(complain: widget.complain, budgetItems: items),
                    // Table Header
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      child: const _TableHeaderRow(),
                    ),
                    const SizedBox(height: 8),

                    // Table Content
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _BudgetItemRow(
                            item: item,
                            currencyFormat: currencyFormat,
                          );
                        },
                      ),
                    ),

                    const Divider(height: 24),

                    // Total Budget
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: colorScheme.primary.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Budget:',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currencyFormat.format(totalBudget),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if ( widget.complain.isApprovedBudget! || widget.complain.isBudgetReviewRequested!)
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.complain.isApprovedBudget! ? "Budget Approved, Waiting for Agency" : 'Waiting for budget review' ,
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      )
                    else
                      _ActionButtons(
                        onReviewPressed: () => _handleReviewRequest(context),
                        onPayPressed: () =>
                            _handlePayment(context, totalBudget),
                        colorScheme: colorScheme,
                        complain: widget.complain,
                      ),

                  ],
                ),
              );
            }

            // Initial state
            return const Center(child: Text('No budget data available'));
          },
        ),
      ),
    );
  }

  void _handleReviewRequest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget review requested')),
    );
  }

  void _handlePayment(BuildContext context, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text('Proceed with payment of \$${amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Payment of \$${amount.toStringAsFixed(2)} processed')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}


class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Description',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Qty',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Unit Price',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Total',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _BudgetItemRow extends StatelessWidget {
  final BudgetItem item;
  final NumberFormat currencyFormat;

  const _BudgetItemRow({
    required this.item,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.description,
              style: textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(item.costPerUnit),
              style: textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(item.total),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onReviewPressed;
  final VoidCallback onPayPressed;
  final ColorScheme colorScheme;
  final ComplainEntity complain;

  const _ActionButtons({
    required this.onReviewPressed,
    required this.onPayPressed,
    required this.colorScheme,
    required this.complain,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBudgetCubit, PostBudgetState>(
      listener: (context, state) {
        if (state is PostBudgetSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Budget accepted successfully'),
              backgroundColor: Colors.green.shade600, // Green background
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Pop back after a short delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ComplainsListScreen()),
            );
          });
        } else if (state is PostBudgetFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.reviews_outlined),
              onPressed:() => _showAcceptBudgetDialog(context, "Review Request", true),
              label: const Text('Request Review'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.payment_outlined),
              onPressed: () => _showAcceptBudgetDialog(context, "Accept Budget", false),
              label: const Text('Accept Budget'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAcceptBudgetDialog(BuildContext context, String dialogTitle, bool isReview) {
    final commentController = TextEditingController();
    final postBudgetCubit = context.read<PostBudgetCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please add any comments:'),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your comments...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final tenantID = prefs.getString('tenantID') ?? '';
              final agencyID = prefs.getString('agencyID') ?? '';

              if (tenantID.isEmpty || agencyID.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User information not found')),
                );
                return;
              }

              final now = DateTime.now();
              final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);

              final model = BudgetPostModel(
                complainID: complain.complainID,
                comments: commentController.text,
                tenantID: tenantID,
                agencyID: agencyID,
                createdDate: formattedDate,
                ticketNo: complain.ticketNo,
              );

              postBudgetCubit.postBudget(budgetModel: model, isReview: isReview);
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class ComplainDetailsCard extends StatelessWidget {
  final ComplainEntity complain;
  final List<BudgetItem> budgetItems;

  const ComplainDetailsCard({super.key, required this.complain,required this.budgetItems });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    //final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket #: ${complain.ticketNo}',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Description:',
            //   style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            // ),
            // const SizedBox(height: 4),
            // Text(
            //   complain.complainName ?? 'No description provided.',
            //   style: textTheme.bodyMedium,
            // ),
            const SizedBox(height: 12),
            Text(
              'Budget Updated: ${formatDateTimeReadable(DateTime.tryParse(budgetItems.first.updatedDate!) ?? DateTime.now())}',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

