import { corsHeaders } from '../_shared/cors.ts';

interface EmailData {
  applicationData: {
    first_name: string;
    last_name: string;
    email: string;
    phone: string;
    linkedin?: string;
  };
  recipientEmail: string;
}

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY');

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: corsHeaders,
    });
  }

  try {
    const { applicationData, recipientEmail }: EmailData = await req.json();

    if (!RESEND_API_KEY) {
      console.error('RESEND_API_KEY not set');
      return new Response(
        JSON.stringify({ error: 'Email service not configured' }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      );
    }

    const emailHtml = `
      <h2>New Job Application Received</h2>
      <p>A new application has been submitted:</p>
      <ul>
        <li><strong>Name:</strong> ${applicationData.first_name} ${applicationData.last_name}</li>
        <li><strong>Email:</strong> ${applicationData.email}</li>
        <li><strong>Phone:</strong> ${applicationData.phone}</li>
        ${applicationData.linkedin ? `<li><strong>LinkedIn:</strong> ${applicationData.linkedin}</li>` : ''}
      </ul>
      <p>Please check the admin dashboard to download their CV.</p>
    `;

    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: 'Recruitment System <onboarding@resend.dev>',
        to: [recipientEmail],
        subject: `New Application: ${applicationData.first_name} ${applicationData.last_name}`,
        html: emailHtml,
      }),
    });

    if (!res.ok) {
      const errorData = await res.text();
      console.error('Resend API error:', errorData);
      throw new Error('Failed to send email');
    }

    const data = await res.json();

    return new Response(
      JSON.stringify({ message: 'Email sent successfully', id: data.id }),
      {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );

  } catch (error) {
    console.error('Error sending email:', error);
    return new Response(
      JSON.stringify({ error: 'Failed to send email notification' }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    );
  }
});