// lib/core/theme/app_dimens.dart
//
// Phase 12 — the tightened, single source of truth for spacing / radius / size.
// Replaces the scattered EdgeInsets.all(16), radius: 30, fontSize: 24 magic
// numbers that make the current UI feel oversized and inconsistent.
//
// Design intent: DENSER than today. The app reads as "ugly/huge" mostly
// because every box uses 16px padding + 16px margin + 30px radius. We cut the
// base scale and route everything through these constants.
//
// Pair with Responsive (responsive.dart) when a value must adapt per device:
//   padding: EdgeInsets.all(context.r.dp(AppDimens.cardPad))

import 'package:flutter/widgets.dart';

class AppDimens {
  AppDimens._();

  // ── Spacing scale (4-pt grid, tightened) ──────────────────────────────────
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12; // was the de-facto 16 everywhere → now 12
  static const double lg = 16;
  static const double xl = 24;

  // Canonical paddings (use these, not raw EdgeInsets).
  static const EdgeInsets cardPadding = EdgeInsets.all(md); // 12, not 16
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const EdgeInsets listGap = EdgeInsets.only(bottom: sm);

  // ── Radius scale (collapse 8/12/14/16/18/22/28/30 → 3 values) ─────────────
  static const double rSm = 10;
  static const double rMd = 14;
  static const double rLg = 18; // top of the scale; nothing rounder than this
  static const double rPill = 999;

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(rSm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(rMd));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(rLg));

  // ── Component sizes ───────────────────────────────────────────────────────
  static const double avatarSm = 18; // was radius: 30 in user_box → too big
  static const double avatarMd = 22;
  static const double avatarLg = 32;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double chipHeight = 26;
  static const double buttonHeight = 46; // was ~56 implied by vertical:16
  static const double navBarHeight = 64;

  // ── Typography sizes (base values; pass through context.r.sp() to scale) ──
  // The app over-uses 16–24 for body content. New scale tops out lower.
  static const double fHero = 22; // page hero only
  static const double fH1 = 18;
  static const double fH2 = 16;
  static const double fTitle = 14; // card titles
  static const double fBody = 13;
  static const double fCaption = 11;
  static const double fMicro = 10;
}
