// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("room:lobby", {});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) });

$(document).ready(function(){
  const colorPickerInput = $(".color-picker input[name='color-picker']");
  const submitButton = $('button.submit-palette');
  const paletteInputs = $('.palette-inputs input');

  colorPickerInput.on('keypress', e => {
    $('.color-picker-error').html("");

    if (e.which == 13) {
      const rgbInput = colorPickerInput.val().match(/^\d{1,3},\s*\d{1,3},\s*\d{1,3}$/g);
      const colorPickerBar = $(".color-picker .color-picker-bar");

      if (rgbInput){
        colorPickerBar.css('background-color', `rgb(${rgbInput[0]})`);
      } else {
        $('.color-picker-error').html("enter value in this format: 123,456,789");
      }
    }
  });

  paletteInputs.on('keypress', e => {
    $('.palette-error').html("");

    if (e.which == 13) {
      const rgbInput = $(e.target).val().match(/^\d{1,3},\s*\d{1,3},\s*\d{1,3}$/g);
      const paletteColorBar = $(e.target).closest('.column').find('.color-bar');

      if (rgbInput){
        paletteColorBar.css('background-color', `rgb(${rgbInput[0]})`);
      } else {
        $('.palette-error').html("enter value in this format: 123,456,789");
      }
    }
  });

  submitButton.on('click', e => {
    const paletteInputs = $(".palette-inputs input");
    
    const paletteColors = [];
    paletteInputs.each( index => {
      paletteColors.push(paletteInputs[index].value);
    });

    channel.push("new_palette", { body: { colors: paletteColors } });

    paletteInputs.each( index => {
      paletteInputs[index].value = '';
    });    

    const paletteColorBars = $('.palette-inputs .color-bar');

    paletteColorBars.each( index => {
      $(paletteColorBars[index]).css('background-color', 'rgb(170,170,170)');
    });

  });

  channel.on("new_palette", payload => {
    const paletteContainer = $('#palettes');
    const colors = payload.colors || payload.body.colors;
    const paletteId = payload.id || payload.body.id;

    paletteContainer.append(`<ul class='palette-list' id='${paletteId}'><li class='delete-palette'>X</li></ul>`);
    const paletteList = $('ul.palette-list');

    colors.forEach((color, index) => {
      paletteList.last().append(`<li class='palette-list-input'><input id='[${paletteId},${index}]' type='text' value='${color}'></input></li>`);
      paletteList.last().append(`<li class='palette-list-item' style='width:60px;height:20px;background-color:rgb(${color})'></li>`);
    });

    const editPaletteInputs = $('#palettes .palette-list-input input');
    editPaletteInputs.on('keypress', editPalette);

    const deletePaletteMarks = $('#palettes .palette-list .delete-palette');
    deletePaletteMarks.on('click', deletePalette);
  });

  channel.on("end_palette_list", payload => {
    const editPaletteInputs = $('#palettes .palette-list-input input');
    const deletePaletteMarks = $('#palettes .palette-list .delete-palette');
    
    editPaletteInputs.on('keypress', editPalette);
    deletePaletteMarks.on('click', deletePalette);
  });

  channel.on("delete_palette", payload => {
    $(`.palette-list#${payload.body.id}`).remove()
  });

  channel.on("update_palette", payload => {
    const paletteId = payload.body.id;
    const colors = payload.body.colors;
    const palette = $(`ul.palette-list#${paletteId}`)

    palette.empty();
    palette.append("<li class='delete-palette'>X</li>")

    colors.forEach((color, index) => {
      palette.append(`<li class='palette-list-input'><input id='[${paletteId},${index}]' type='text' value='${color}'></input></li>`);
      palette.append(`<li class='palette-list-item' style='width:60px;height:20px;background-color:rgb(${color})'></li>`);
    }); 
    
    const editPaletteInputs = $('#palettes .palette-list-input input');
    editPaletteInputs.on('keypress', editPalette);

    const deletePaletteMarks = $('#palettes .palette-list .delete-palette');
    deletePaletteMarks.on('click', deletePalette);
  });

  function editPalette(e){
    $('.palette-list-error').html("");
      
      if (e.which == 13) {
        const rgbInput = $(e.target).val().match(/^\d{1,3},\s*\d{1,3},\s*\d{1,3}$/g);
        const paletteColorBar = $(e.target).closest('li').next('.palette-list-item');
        const paletteInfo = JSON.parse($(e.target).attr('id'));
        const paletteId = paletteInfo[0];
        const paletteIndex = paletteInfo[1]

        if (rgbInput){
          paletteColorBar.css('background-color', `rgb(${rgbInput[0]})`);
          
          channel.push("update_palette", { body: { color: rgbInput[0], id: paletteId, palette_index: paletteIndex } });

        } else {
          $('.palette-list-error').html("enter value in this format: 123,456,789");
        }
      }
  }

  function deletePalette(e){
    const paletteInfo = $(e.target).next().find('input').attr('id');
    const paletteId = JSON.parse(paletteInfo)[0]

    channel.push("delete_palette", { body: {id: paletteId } });
    $('#palettes').html("")
  }
});

export default socket
