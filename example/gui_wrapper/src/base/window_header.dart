class WindowHeader {
  final bool visible;
  final bool minimizeBox;
  final bool maximizeBox;
  final bool closeBox;
  final bool toolBox;

  const WindowHeader({
    this.visible = true,
    this.minimizeBox = true,
    this.maximizeBox = true,
    this.closeBox = true,
    this.toolBox = false,
  });

  factory WindowHeader.full() => const WindowHeader();

  factory WindowHeader.dialog() => const WindowHeader(
      maximizeBox: false,
      minimizeBox: false
  );

  factory WindowHeader.noClose() => const WindowHeader(closeBox: false);

  factory WindowHeader.hide() => const WindowHeader(visible: false);

  factory WindowHeader.toolBox() => const WindowHeader(toolBox: true);
}
