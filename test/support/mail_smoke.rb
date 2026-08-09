admin = Admin.find_or_initialize_by(email: "ci@example.com")
admin.password = "password123"
admin.save!

class CiMailer < ApplicationMailer
  def smoke(admin)
    @admin = admin

    mail(to: admin.email, subject: "Thomas CI mail smoke test") do |format|
      format.html do
        render(
          inline: '<p>Thomas email delivery works.</p><%= mailkick_unsubscribe_url(@admin, "ci", host: "localhost") %>',
          layout: "mailer"
        )
      end
      format.text { render plain: "Thomas email delivery works." }
    end
  end
end

message = CiMailer.smoke(admin).deliver_now

raise "missing unsubscribe header" unless message["List-Unsubscribe"]&.value&.include?("/mailkick/")
raise "missing one-click header" unless message["List-Unsubscribe-Post"]&.value == "List-Unsubscribe=One-Click"

puts "SMTP delivery and unsubscribe headers verified"
