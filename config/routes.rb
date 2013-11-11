MailruSecretQuestionParser::Application.routes.draw do
  root :to => 'parser#index'
  get 'mail_parse' => 'parser#mail_parse', as: 'mail_parse'
  post 'parse_mails' => 'parser#parse_mails', as: 'parse_mails'
  get 'parsing' => 'parser#parsing', as: 'parsing'
end
