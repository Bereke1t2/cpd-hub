import 'package:flutter/material.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
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
    final sc = context.sc;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: UiConstants.mainTextColor, size: 24 * sc),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8 * sc, vertical: 4 * sc),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [UiConstants.primaryButtonColor, UiConstants.primaryButtonColor.withValues(alpha: 0.6)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "ELITE",
                style: TextStyle(color: Colors.black, fontSize: 10 * sc, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
            SizedBox(width: 12 * sc),
            Expanded(
              child: Hero(
                tag: 'problem_${widget.problemData['title']}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.problemData['title'] ?? "Problem Details",
                    style: TextStyle(
                      color: UiConstants.mainTextColor,
                      fontSize: 18 * sc,
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
            icon: Icon(Icons.share_outlined, size: 20 * sc, color: UiConstants.mainTextColor.withValues(alpha: 0.7)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, size: 20 * sc, color: UiConstants.mainTextColor.withValues(alpha: 0.7)),
            onPressed: () {},
          ),
          SizedBox(width: 8 * sc),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: UiConstants.primaryButtonColor,
          unselectedLabelColor: UiConstants.subtitleTextColor.withValues(alpha: 0.5),
          indicatorColor: UiConstants.primaryButtonColor,
          indicatorWeight: 3,
          labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 13 * sc),
          tabs: [
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
          _buildDescriptionTab(sc),
          _buildPlaceholderTab("Editorial Content Coming Soon", sc),
          _buildPlaceholderTab("Community Solutions", sc),
          _buildPlaceholderTab("Your Past Submissions", sc),
        ],
      ),
      bottomNavigationBar: _buildBottomActionPanel(context),
    );
  }

  Widget _buildDescriptionTab(double sc) {
    final tags = widget.problemData['tags'];
    final tagList = tags is List ? tags.cast<String>() : <String>[];
    final description = widget.problemData['description'] as String? ?? '';
    final examples = widget.problemData['examples'];
    final exampleList = examples is List ? examples.cast<Map<String, dynamic>>() : <Map<String, dynamic>>[];
    final constraints = widget.problemData['constraints'];
    final constraintList = constraints is List ? constraints.cast<String>() : <String>[];

    return SingleChildScrollView(
      padding: EdgeInsets.all(20 * sc),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DifficultyBox(difficulty: widget.problemData['difficulty'] ?? "Medium"),
              SizedBox(width: 12 * sc),
              Icon(Icons.thumb_up_rounded, size: 14 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.5)),
              SizedBox(width: 4 * sc),
              Text("${widget.problemData['likedCount'] ?? "0"}", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 12 * sc)),
              SizedBox(width: 12 * sc),
              Icon(Icons.thumb_down_rounded, size: 14 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.5)),
              SizedBox(width: 4 * sc),
              Text("${widget.problemData['dislikedCount'] ?? "0"}", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 12 * sc)),
              if (widget.problemData['isSolved'] == true) ...[
                SizedBox(width: 12 * sc),
                Icon(Icons.check_circle_rounded, size: 16 * sc, color: Colors.greenAccent),
                SizedBox(width: 4 * sc),
                Text("Solved", style: TextStyle(color: Colors.greenAccent, fontSize: 12 * sc, fontWeight: FontWeight.w600)),
              ],
            ],
          ),
          SizedBox(height: 24 * sc),
          Text(
            "Problem Statement",
            style: TextStyle(color: UiConstants.mainTextColor, fontSize: 20 * sc, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 16 * sc),
          if (description.isNotEmpty)
            Text(
              description,
              style: TextStyle(
                color: UiConstants.mainTextColor.withValues(alpha: 0.9),
                fontSize: 16 * sc,
                height: 1.7,
                letterSpacing: 0.2,
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20 * sc),
              decoration: BoxDecoration(
                color: UiConstants.infoBackgroundColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Icon(Icons.description_outlined, size: 32 * sc, color: UiConstants.subtitleTextColor.withValues(alpha: 0.3)),
                  SizedBox(height: 8 * sc),
                  Text(
                    "Problem description will be loaded from the server.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 13 * sc),
                  ),
                ],
              ),
            ),
          if (exampleList.isNotEmpty) ...[
            SizedBox(height: 32 * sc),
            ...exampleList.asMap().entries.map((entry) {
              final ex = entry.value;
              return _buildExample(
                entry.key + 1,
                ex['input'] as String? ?? '',
                ex['output'] as String? ?? '',
                ex['explanation'] as String? ?? '',
                sc,
              );
            }),
          ],
          if (constraintList.isNotEmpty) ...[
            SizedBox(height: 32 * sc),
            Text("Constraints:", style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold, fontSize: 16 * sc)),
            SizedBox(height: 8 * sc),
            ...constraintList.map((c) => _buildConstraint(c, sc)),
          ],
          if (tagList.isNotEmpty) ...[
            SizedBox(height: 40 * sc),
            Text("Topic Tags", style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold, fontSize: 16 * sc)),
            SizedBox(height: 16 * sc),
            Wrap(
              spacing: 12 * sc,
              runSpacing: 12 * sc,
              children: tagList.map((tag) => TagBox(tag: tag)).toList(),
            ),
          ],
          SizedBox(height: 100 * sc),
        ],
      ),
    );
  }

  Widget _buildExample(int num, String input, String output, String explanation, double sc) {
    return Container(
      margin: EdgeInsets.only(bottom: 20 * sc),
      padding: EdgeInsets.all(16 * sc),
      decoration: BoxDecoration(
        color: UiConstants.infoBackgroundColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Example $num:", style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.bold, fontSize: 14 * sc)),
          SizedBox(height: 12 * sc),
          _buildExampleRow("Input", input, sc),
          SizedBox(height: 8 * sc),
          _buildExampleRow("Output", output, sc),
          if (explanation.isNotEmpty) ...[
            SizedBox(height: 8 * sc),
            _buildExampleRow("Explanation", explanation, sc),
          ],
        ],
      ),
    );
  }

  Widget _buildExampleRow(String label, String value, double sc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80 * sc, child: Text("$label: ", style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.7), fontSize: 13 * sc))),
        Expanded(child: Text(value, style: TextStyle(color: UiConstants.mainTextColor, fontSize: 13 * sc, fontFamily: 'monospace'))),
      ],
    );
  }

  Widget _buildConstraint(String text, double sc) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6 * sc),
      child: Row(
        children: [
          Icon(Icons.circle, size: 4 * sc, color: UiConstants.subtitleTextColor),
          SizedBox(width: 8 * sc),
          Text(text, style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.8), fontSize: 13 * sc)),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String message, double sc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_rounded, size: 60 * sc, color: UiConstants.primaryButtonColor.withValues(alpha: 0.3)),
          SizedBox(height: 16 * sc),
          Text(message, style: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.5), fontSize: 14 * sc)),
        ],
      ),
    );
  }

  Widget _buildBottomActionPanel(BuildContext context) {
    final sc = context.sc;
    return Container(
      padding: EdgeInsets.fromLTRB(16 * sc, 12 * sc, 16 * sc, 32 * sc),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12 * sc),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.code_rounded, color: UiConstants.primaryButtonColor, size: 20 * sc),
          ),
          SizedBox(width: 12 * sc),
          Expanded(
            child: SizedBox(
              height: 48 * sc,
              child: ElevatedButton(
                onPressed: () => _showCodeEditor(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: UiConstants.primaryButtonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 14 * sc),
                ),
                child: const Text("SOLVE PROBLEM"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCodeEditor(BuildContext context) {
    final sc = context.sc;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            _buildEditorHeader(context),
            Expanded(
              child: TextField(
                controller: _codeController,
                maxLines: null,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white70,
                  fontSize: 14 * sc,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20 * sc),
                  border: InputBorder.none,
                ),
              ),
            ),
            _buildCodeToolbar(context),
            _buildEditorActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorHeader(BuildContext context) {
    final sc = context.sc;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 * sc, vertical: 12 * sc),
      decoration: BoxDecoration(
        color: const Color(0xFF252526),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.terminal_rounded, color: Colors.blueAccent, size: 20 * sc),
              SizedBox(width: 10 * sc),
              Text("Python3", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14 * sc)),
              Icon(Icons.arrow_drop_down, color: Colors.white54, size: 24 * sc),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Code copied to clipboard!", style: TextStyle(fontSize: 14 * sc))),
                  );
                },
                icon: Icon(Icons.copy_rounded, color: Colors.white54, size: 18 * sc),
                tooltip: "Copy Code",
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 24 * sc),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeToolbar(BuildContext context) {
    final sc = context.sc;
    final symbols = ['(', ')', '{', '}', '[', ']', ':', '.', ';', '_', '=', '+', '-', '*', '/', '<', '>'];
    return Container(
      height: 44 * sc,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        border: Border(top: BorderSide(color: Colors.white10), bottom: BorderSide(color: Colors.white10)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8 * sc),
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
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14 * sc),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditorActions(BuildContext context) {
    final sc = context.sc;
    return Container(
      padding: EdgeInsets.fromLTRB(20 * sc, 16 * sc, 20 * sc, 32 * sc),
      decoration: BoxDecoration(
        color: const Color(0xFF252526),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text("Run", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14 * sc)),
          ),
          SizedBox(width: 16 * sc),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Solution Submitted! Evaluating...", style: TextStyle(fontSize: 14 * sc)),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 * sc),
            ),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
