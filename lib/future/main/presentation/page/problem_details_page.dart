import 'package:flutter/material.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import '../widget/difficulty_box.dart';
import '../widget/tag_box.dart';

class ProblemDetailsPage extends StatefulWidget {
  final Map<String, dynamic> problemData;

  const ProblemDetailsPage({super.key, required this.problemData});

  @override
  State<ProblemDetailsPage> createState() => _ProblemDetailsPageState();
}

class _ProblemDetailsPageState extends State<ProblemDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _codeController = TextEditingController(
    text: "class Solution:\n    def solve(self, nums: List[int]) -> int:\n        # Write your code here\n        pass",
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: UiConstants.mainTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [UiConstants.primaryButtonColor, UiConstants.primaryButtonColor.withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "ELITE",
                style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Hero(
                tag: 'problem_${widget.problemData['title']}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.problemData['title'] ?? "Problem Details",
                    style: const TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, size: 20, color: UiConstants.mainTextColor.withOpacity(0.7)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, size: 20, color: UiConstants.mainTextColor.withOpacity(0.7)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: UiConstants.primaryButtonColor,
          unselectedLabelColor: UiConstants.subtitleTextColor.withOpacity(0.5),
          indicatorColor: UiConstants.primaryButtonColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          tabs: const [
            Tab(text: "Description"),
            Tab(text: "Editorial"),
            Tab(text: "Solutions"),
            Tab(text: "Submissions"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(),
          _buildPlaceholderTab("Editorial Content Coming Soon"),
          _buildPlaceholderTab("Community Solutions"),
          _buildPlaceholderTab("Your Past Submissions"),
        ],
      ),
      bottomNavigationBar: _buildBottomActionPanel(),
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DifficultyBox(difficulty: widget.problemData['difficulty'] ?? "Medium"),
              const SizedBox(width: 12),
              Icon(Icons.thumb_up_rounded, size: 14, color: UiConstants.subtitleTextColor.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text("${widget.problemData['likedCount'] ?? "0"}", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 12)),
              const SizedBox(width: 12),
              Icon(Icons.thumb_down_rounded, size: 14, color: UiConstants.subtitleTextColor.withOpacity(0.5)),
              const SizedBox(width: 4),
              Text("${widget.problemData['dislikedCount'] ?? "0"}", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Problem Statement",
            style: TextStyle(color: UiConstants.mainTextColor, fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Text(
            "Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.\n\nYou may assume that each input would have exactly one solution, and you may not use the same element twice.\n\nYou can return the answer in any order.",
            style: TextStyle(
              color: UiConstants.mainTextColor.withOpacity(0.9),
              fontSize: 16,
              height: 1.7,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 32),
          _buildExample(1, "nums = [2,7,11,15], target = 9", "[0,1]", "Because nums[0] + nums[1] == 9, we return [0, 1]."),
          _buildExample(2, "nums = [3,2,4], target = 6", "[1,2]", ""),
          const SizedBox(height: 32),
          const Text("Constraints:", style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildConstraint("2 <= nums.length <= 104"),
          _buildConstraint("-109 <= nums[i] <= 109"),
          _buildConstraint("-109 <= target <= 109"),
          const SizedBox(height: 40),
          const Text("Topic Tags", style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              TagBox(tag: "Array"),
              TagBox(tag: "Hash Table"),
              TagBox(tag: "Sliding Window"),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildExample(int num, String input, String output, String explanation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Example $num:", style: const TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _buildExampleRow("Input", input),
          const SizedBox(height: 8),
          _buildExampleRow("Output", output),
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildExampleRow("Explanation", explanation),
          ],
        ],
      ),
    );
  }

  Widget _buildExampleRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text("$label: ", style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.7), fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: UiConstants.mainTextColor, fontSize: 13, fontFamily: 'monospace'))),
      ],
    );
  }

  Widget _buildConstraint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 4, color: UiConstants.subtitleTextColor),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.8), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_rounded, size: 60, color: UiConstants.primaryButtonColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: UiConstants.subtitleTextColor.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _buildBottomActionPanel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.code_rounded, color: UiConstants.primaryButtonColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => _showCodeEditor(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UiConstants.primaryButtonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w900),
                ),
                child: const Text("SOLVE PROBLEM"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCodeEditor() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            _buildEditorHeader(),
            Expanded(
              child: TextField(
                controller: _codeController,
                maxLines: null,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white70,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  border: InputBorder.none,
                ),
              ),
            ),
            _buildCodeToolbar(),
            _buildEditorActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF252526),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.terminal_rounded, color: Colors.blueAccent, size: 20),
              SizedBox(width: 10),
              Text("Python3", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down, color: Colors.white54),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                   // Simulate copy
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Code copied to clipboard!")),
                   );
                },
                icon: const Icon(Icons.copy_rounded, color: Colors.white54, size: 18),
                tooltip: "Copy Code",
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeToolbar() {
    final symbols = ['(', ')', '{', '}', '[', ']', ':', '.', ';', '_', '=', '+', '-', '*', '/', '<', '>'];
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        border: Border(top: BorderSide(color: Colors.white10), bottom: BorderSide(color: Colors.white10)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: symbols.length,
        itemBuilder: (context, index) {
          return IconButton(
            onPressed: () {
              final text = _codeController.text;
              final selection = _codeController.selection;
              final newText = text.replaceRange(selection.start, selection.end, symbols[index]);
              _codeController.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: selection.start + symbols[index].length),
              );
            },
            icon: Text(
              symbols[index],
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditorActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF252526),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text("Run", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                   content: Text("Solution Submitted! Evaluating..."),
                   backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
