class BookingFlow extends StatefulWidget {
  @override
  _BookingFlowState createState() => _BookingFlowState();
}

class _BookingFlowState extends State<BookingFlow> 
  with TickerProviderStateMixin {
  
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentStep = 0;
  final _steps = [BookingStep.dates, BookingStep.room, BookingStep.payment];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  Widget _buildStepContent() {
    return PageView.builder(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _steps.length,
      itemBuilder: (ctx, i) => AnimatedBuilder(
        animation: _progressController,
        builder: (ctx, child) {
          return Transform.translate(
            offset: Offset(50 * (1 - _progressController.value), 
            child: Opacity(
              opacity: _progressController.value,
              child: child,
            ),
          );
        },
        child: _StepContent(step: _steps[i]),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      _progressController.reset();
      _progressController.forward();
    } else {
      _showConfirmation();
    }
  }

  void _showConfirmation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _BookingConfirmation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BookingProgressBar(currentStep: _currentStep),
      body: _buildStepContent(),
      floatingActionButton: _FloatingNextButton(
        onPressed: _nextStep,
        progress: _progressController,
      ),
    );
  }
}

class _FloatingNextButton extends ImplicitlyAnimatedWidget {
  final VoidCallback onPressed;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 + (0.2 * progress.value),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        label: Text('Continue'),
        icon: Icon(Icons.arrow_forward),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}