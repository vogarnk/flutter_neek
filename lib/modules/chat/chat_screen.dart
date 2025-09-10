import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/chat_service.dart';
import 'package:neek/models/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  final String? conversationId;
  
  const ChatScreen({super.key, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  String? _conversationId;
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      if (widget.conversationId != null) {
        // Cargar conversación existente específica
        _conversationId = widget.conversationId;
        final messages = await ChatService.getMessages(_conversationId!);
        
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
          _isLoading = false;
        });
        
        // Marcar mensajes como leídos
        ChatService.markAsRead(_conversationId!);
      } else {
        // Inicializar chat usando la nueva API (crear nueva o obtener existente)
        final response = await ChatService.initializeChat();
        
        _conversationId = response.conversationId;
        
        // Limpiar mensajes anteriores
        _messages.clear();
        
        if (response.isNewConversation && response.welcomeMessage != null) {
          // Nueva conversación con mensaje de bienvenida
          _messages.add(response.welcomeMessage!);
        } else if (response.existingMessages != null) {
          // Conversación existente con mensajes previos
          _messages.addAll(response.existingMessages!);
        }

        setState(() {
          _isLoading = false;
        });
        
        // Marcar mensajes como leídos
        if (_conversationId != null) {
          ChatService.markAsRead(_conversationId!);
        }
      }
      
      _scrollToBottom();
    } catch (e) {
      print('Error al inicializar chat: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al inicializar chat: $e'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  // Método para refrescar mensajes (obtener nuevos mensajes del servidor)
  Future<void> _refreshMessages() async {
    if (_conversationId == null || _isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      final newMessages = await ChatService.getMessages(_conversationId!);
      
      // Actualizar solo si hay mensajes nuevos
      if (newMessages.length != _messages.length) {
        setState(() {
          _messages.clear();
          _messages.addAll(newMessages);
        });
        
        // Marcar como leídos los nuevos mensajes
        ChatService.markAsRead(_conversationId!);
        _scrollToBottom();
      }
    } catch (e) {
      print('Error al refrescar mensajes: $e');
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _conversationId == null) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    try {
      setState(() {
        _isTyping = true;
      });

      // Enviar mensaje usando la nueva API
      final sentMessage = await ChatService.sendMessage(
        conversationId: _conversationId!,
        text: messageText,
      );

      setState(() {
        _messages.add(sentMessage);
        _isTyping = false;
      });

      _scrollToBottom();

      // La respuesta del bot llegará automáticamente vía webhook
      // No necesitamos simular una respuesta
    } catch (e) {
      print('Error al enviar mensaje: $e');
      setState(() {
        _isTyping = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar mensaje: $e'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickFile() async {
    if (_conversationId == null) return;
    
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final platformFile = result.files.first;
        
        if (platformFile.path == null) {
          throw Exception('No se pudo acceder al archivo');
        }

        final file = File(platformFile.path!);
        
        setState(() {
          _isTyping = true;
        });

        // Enviar archivo usando la nueva API
        final sentMessage = await ChatService.sendMessage(
          conversationId: _conversationId!,
          text: 'Archivo enviado: ${platformFile.name}',
          file: file,
        );

        setState(() {
          _messages.add(sentMessage);
          _isTyping = false;
        });
        
        _scrollToBottom();
      }
    } catch (e) {
      print('Error al enviar archivo: $e');
      setState(() {
        _isTyping = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar archivo: $e'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.textWhite,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Chat de Ayuda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _isRefreshing ? null : _refreshMessages,
            icon: _isRefreshing 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                    ),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Actualizar mensajes',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.smart_toy,
                color: AppColors.textWhite,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? AppColors.primary 
                    : AppColors.contrastBackground,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.filePath != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            message.fileType == 'pdf' ? Icons.picture_as_pdf : Icons.image,
                            color: AppColors.textWhite,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              message.fileName ?? 'Archivo',
                              style: const TextStyle(
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: AppColors.textWhite.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.textWhite,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppColors.textWhite,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.contrastBackground,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textWhite.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.contrastBackground.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _pickFile,
            icon: Icon(
              Icons.attach_file,
              color: AppColors.textGray400,
            ),
            tooltip: 'Adjuntar archivo',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.contrastBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.textWhite),
                decoration: const InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  hintStyle: TextStyle(color: AppColors.textGray400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}


