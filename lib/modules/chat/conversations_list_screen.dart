import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/chat_service.dart';
import 'package:neek/modules/chat/chat_screen.dart';

class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() => _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  List<ChatConversation> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await ChatService.getUserConversations();
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar conversaciones: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createNewConversation() async {
    try {
      // Navegar directamente al chat, que creará una nueva conversación
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      ).then((_) {
        // Recargar conversaciones cuando regrese
        _loadConversations();
      });
    } catch (e) {
      print('Error al crear nueva conversación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear nueva conversación: $e'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _openConversation(ChatConversation conversation) {
    // Navegar al chat con la conversación específica
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(conversationId: conversation.id),
      ),
    ).then((_) {
      // Recargar conversaciones cuando regrese
      _loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        title: const Text(
          'Mis Conversaciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadConversations,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _conversations.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadConversations,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      return _buildConversationItem(_conversations[index]);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewConversation,
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add_comment,
          color: AppColors.textWhite,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No tienes conversaciones',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Inicia una nueva conversación con nuestro\nasistente virtual',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textGray400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _createNewConversation,
            icon: const Icon(Icons.add_comment),
            label: const Text('Nuevo mensaje'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationItem(ChatConversation conversation) {
    return Card(
      color: AppColors.contrastBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openConversation(conversation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: AppColors.textWhite,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Asistente Virtual',
                          style: TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatDate(conversation.updatedAt),
                          style: TextStyle(
                            color: AppColors.textGray400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.lastMessage?.text ?? 'Nueva conversación',
                      style: TextStyle(
                        color: AppColors.textGray400,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (conversation.unreadCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    conversation.unreadCount.toString(),
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
