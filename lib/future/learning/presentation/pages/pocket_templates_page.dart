import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cpd_hub/core/theme/theme_ext.dart';
import 'package:cpd_hub/core/ui_constants.dart';
import 'package:cpd_hub/future/main/presentation/page/base_page.dart';

class _Snippet {
  final String id;
  final String title;
  final String lang;
  final String code;

  const _Snippet(this.id, this.title, this.lang, this.code);
}

/// Searchable template library with Copy (C++, Java, Python, Go).
class PocketTemplatesPage extends StatefulWidget {
  const PocketTemplatesPage({super.key});

  @override
  State<PocketTemplatesPage> createState() => _PocketTemplatesPageState();
}

class _PocketTemplatesPageState extends State<PocketTemplatesPage> with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _search = TextEditingController();

  static const _snippets = [
    _Snippet('dij_cpp', 'Dijkstra (priority_queue)', 'C++', r'''
typedef pair<int,int> pii;
vector<int> dijkstra(int s, const vector<vector<pii>>& g) {
  const int INF = 1e9;
  vector<int> d(g.size(), INF); d[s]=0;
  priority_queue<pii, vector<pii>, greater<pii>> pq;
  pq.push({0,s});
  while(!pq.empty()){
    auto [du,u]=pq.top(); pq.pop();
    if(du!=d[u]) continue;
    for(auto [v,w]: g[u]) if(d[v]>du+w){ d[v]=du+w; pq.push({d[v],v});}
  }
  return d;
}'''),
    _Snippet('dsu_cpp', 'DSU', 'C++', r'''
struct DSU {
  vector<int> p, r;
  DSU(int n): p(n),r(n){ iota(p.begin(),p.end(),0); }
  int find(int x){ return p[x]==x?x:p[x]=find(p[x]); }
  bool join(int a,int b){
    a=find(a); b=find(b);
    if(a==b) return false;
    if(r[a]<r[b]) swap(a,b);
    p[b]=a; if(r[a]==r[b]) r[a]++;
    return true;
  }
};'''),
    _Snippet('fast_py', 'Fast I/O', 'Python', r'''
import sys
inp = sys.stdin.readline
def ints(): return map(int, inp().split())
n, m = ints()
'''),
    _Snippet('dij_go', 'Dijkstra sketch', 'Go', r'''
type edge struct{ to, w int }
func dijkstra(s int, g [][]edge) []int {
    dist := make([]int, len(g))
    for i := range dist { dist[i] = 1e9 }
    dist[s] = 0
    // heap.Push...
    return dist
}'''),
    _Snippet('java_io', 'FastJava Scanner', 'Java', r'''
static class FastScanner {
  BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
  StringTokenizer st = new StringTokenizer("");
  String next() throws IOException {
    while (!st.hasMoreTokens()) st = new StringTokenizer(br.readLine());
    return st.nextToken();
  }
  int nextInt() throws IOException { return Integer.parseInt(next()); }
}'''),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sc = context.sc;
    return BasePage(
      showBackButton: true,
      selectedIndex: 0,
      title: 'Pocket templates',
      subtitle: 'Copy snippets to desktop',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16 * sc, 8 * sc, 16 * sc, 0),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: Colors.white, fontSize: 14 * sc),
              decoration: InputDecoration(
                hintText: 'Search Dijkstra, DSU, fast I/O…',
                hintStyle: TextStyle(color: UiConstants.subtitleTextColor.withValues(alpha: 0.4)),
                prefixIcon: Icon(Icons.search_rounded, color: UiConstants.primaryButtonColor),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.06),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.white12)),
              ),
            ),
          ),
          TabBar(
            controller: _tabs,
            labelColor: UiConstants.primaryButtonColor,
            unselectedLabelColor: UiConstants.subtitleTextColor,
            indicatorColor: UiConstants.primaryButtonColor,
            tabs: const [
              Tab(text: 'C++'),
              Tab(text: 'Java'),
              Tab(text: 'Python'),
              Tab(text: 'Go'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _listForLang(sc, 'C++'),
                _listForLang(sc, 'Java'),
                _listForLang(sc, 'Python'),
                _listForLang(sc, 'Go'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listForLang(double sc, String lang) {
    final q = _search.text.toLowerCase();
    var list = _snippets.where((s) => s.lang == lang).toList();
    if (q.isNotEmpty) {
      list = list.where((s) => s.title.toLowerCase().contains(q) || s.code.toLowerCase().contains(q)).toList();
    }

    if (list.isEmpty) {
      return Center(child: Text('No snippets', style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 14 * sc)));
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16 * sc, 12 * sc, 16 * sc, 100 * sc),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final s = list[i];
        return Container(
          margin: EdgeInsets.only(bottom: 12 * sc),
          decoration: BoxDecoration(
            color: UiConstants.infoBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: UiConstants.borderColor.withValues(alpha: 0.12)),
          ),
          child: ExpansionTile(
            title: Text(s.title, style: TextStyle(color: UiConstants.mainTextColor, fontWeight: FontWeight.w800, fontSize: 14 * sc)),
            subtitle: Text(s.lang, style: TextStyle(color: UiConstants.subtitleTextColor, fontSize: 11 * sc)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Copy',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: s.code));
                    if (!mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded),
                  color: UiConstants.primaryButtonColor,
                ),
              ],
            ),
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: s.code));
                    if (!mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
                  },
                  icon: const Icon(Icons.content_copy_rounded, size: 18),
                  label: const Text('Copy full snippet'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16 * sc, 0, 16 * sc, 16 * sc),
                child: SelectableText(
                  s.code,
                  style: TextStyle(
                    color: UiConstants.primaryButtonColor.withValues(alpha: 0.95),
                    fontFamily: 'monospace',
                    fontSize: 11 * sc,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
