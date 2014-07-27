MailruSecretQuestionParser::Application.routes.draw do
  root :to => 'parser#index'
  get 'import' => 'parser#import', as: 'import'
  post 'start_import' => 'parser#start_import', as: 'start_import'
  get 'parsing' => 'parser#parsing', as: 'parsing'
end
