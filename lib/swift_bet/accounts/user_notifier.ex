defmodule SwiftBet.Accounts.UserNotifier do
  import Swoosh.Email

  alias SwiftBet.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"SwiftBet", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end


  def bet_lost(user) do
    deliver(user.email, "Bet status", """
    ==============================
    Hi #{user.email},
  
    Unfortunately, you have lost a bet.
  
    If you have any questions or concerns, feel free to contact us.
  
    ==============================
    """)
  end

def bet_won(user) do
  deliver(user.email, "Congratulations on Winning Your Bet!", """
  ==============================
  Hi #{user.email},

  Congratulations! You have won your bet.

  Enjoy your victory, and if you have any questions or concerns, feel free to contact us
  

  ==============================
  """)
end

  
end
