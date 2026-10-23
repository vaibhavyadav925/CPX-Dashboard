part of '../app.dart';

class OnboardChannelsScreen extends StatelessWidget {
  const OnboardChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DashboardDrawer(currentPage: 'Onboard Channels'),
      appBar: buildCpxBoatAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1000;
          final gap = wide ? 10.0 : 12.0;
          final columns = constraints.maxWidth >= 1100
              ? 3
              : constraints.maxWidth >= 680
              ? 2
              : 1;
          final cardWidth =
              (constraints.maxWidth - gap * (columns - 1)) / columns;
          return SingleChildScrollView(
            padding: EdgeInsets.all(wide ? 14 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 20 : 16,
                    vertical: wide ? 18 : 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B91AD), Color(0xFF0B91AD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome to CPXBOAT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Start by activating a channel to access your dashboard. Add more channels\nlater.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Wrap(
                        spacing: 18,
                        runSpacing: 8,
                        children: const [
                          _OnboardStep(
                            icon: Icons.check_circle_outline,
                            label: 'Connect a channel',
                          ),
                          _OnboardStep(
                            icon: Icons.check_circle_outline,
                            label: 'Set up chatbot in 5 minutes',
                          ),
                          _OnboardStep(
                            icon: Icons.check_circle_outline,
                            label: 'Create and send campaigns',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                const Text(
                  "Choose the channel you'd like to connect first",
                  style: TextStyle(
                    color: navy,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'WhatsApp',
                        description: 'Reach customers instantly on their favorite app with automated messages, notifications, and chatbot support.',
                        icon: Icons.chat,
                        iconColor: Color(0xFF20C765),
                        status: 'Go live under 8 minutes',
                        connected: true,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'RCS',
                        description: 'Deliver rich, interactive messages with buttons, media, and branded experiences to boost engagement.',
                        icon: Icons.chat,
                        iconColor: Color(0xFF4385F5),
                        status: 'Go live in 4-5 days',
                        completed: true,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'SMS',
                        description: 'Send fast, reliable text messages for alerts, OTPs, and bulk campaigns with maximum deliverability.',
                        icon: Icons.sms,
                        iconColor: Color(0xFFFFB400),
                        status: 'Go live in 3-5 days',
                        completed: true,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'Instagram',
                        description: 'Manage Instagram DMs with instant replies and chatbot support.',
                        icon: Icons.camera_alt_outlined,
                        iconColor: Color(0xFFE4408B),
                        status: 'Go live under 2 minutes',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'Facebook',
                        description: 'Handle Messenger chats with automated replies and chatbot support.',
                        icon: Icons.facebook,
                        iconColor: Color(0xFF1877F2),
                        status: 'Go live under 2 minutes',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'Email',
                        description: 'Connect your inbox for email conversations, automation, and support.',
                        icon: Icons.mail,
                        iconColor: Color(0xFFEF4438),
                        status: 'Go live under 2 minutes',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const _OnboardChannelCard(
                        title: 'Web Widget',
                        description: 'Add an intelligent assistant to your website for instant support, lead collection, and automated workflows.',
                        icon: Icons.web_asset,
                        iconColor: Color(0xFF813CF4),
                        status: 'Go live under 2 minutes',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F2F8),
                    border: Border.all(color: const Color(0xFFB6DDEA)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 12,
                    spacing: 16,
                    children: [
                      const SizedBox(
                        width: 390,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.hub_outlined,
                              color: Color(0xFF0B91AD),
                              size: 23,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unlock Fallback campaigns',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'You now have 3 channels connected — set a priority order (e.g. WhatsApp → RCS → SMS) and CPXBOAT will automatically retry on the next channel if a message fails to deliver on the first.',
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 10,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward, size: 14),
                        label: const Text(
                          'Set up Fallback',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
