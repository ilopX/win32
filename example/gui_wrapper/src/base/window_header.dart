class WindowHeader {
  final bool visible;
  final bool minimizeBox;
  final bool maximizeBox;
  final bool closeBox;

  const WindowHeader({
    this.visible = true,
    this.minimizeBox = true,
    this.maximizeBox = true,
    this.closeBox = true,
  });

  factory WindowHeader.full() => const WindowHeader();

  factory WindowHeader.dialog() => const WindowHeader(
      maximizeBox: false,
      minimizeBox: false
  );

  factory WindowHeader.noClose() => const WindowHeader(closeBox: false);

  factory WindowHeader.hide() => const WindowHeader(visible: false);
}
