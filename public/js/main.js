$(window).load(function(){
        
        var to_mark;

        $("[data-toggle]").click(function() {

          var toggle_el = $(this).data("toggle");
          $(toggle_el).toggleClass("open-sidebar");
        });

         $(".swipe-area").swipe({
              swipeStatus:function(event, phase, direction, distance, duration, fingers)
                  {
                      if (phase=="move" && direction =="right") {
                           $(".container").addClass("open-sidebar");
                           return false;
                      }
                      if (phase=="move" && direction =="left") {
                           $(".container").removeClass("open-sidebar");
                           return false;
                      }
                  }
          });


         $('#mark_all').change(function() {
            if($(this).is(":checked")) {
              $('.marked').prop("checked",true);
            }
          });

         $('#mark_all').change(function() {
            if(!$(this).is(":checked")) {
              $('.marked').prop("checked",false);
            }
          });

         $('.marked').change(function(){
            if($(this).is(":checked")){
              $("#read-delete").css("visibility","visible")
            }
         });

         $('.marked').change(function(){
            if(!$(this).is(":checked")){
              $("#read-delete").css("visibility","hidden")
            }
         });


         $(".unread").click(function(){
            var class_name = $(this).attr("class");
            class_name = class_name.split(" ");
            // console.log(class_name);
            class_name = class_name[1];
            $(".unread-mail."+class_name).toggleClass("read-mail message_view "+class_name);
         });

        $(".message_view").click(function(){
          to_mark = this.dataset.mailIndex;
        })
        
        $("#mark_spam").click(function(){
          location.href = "/mark_spam/"+to_mark;
        });

        $("#mark_trash").click(function(){
          location.href = "/mark_trash/"+to_mark;
        });

        $("#mark_important").click(function(){
          $('[data-mail-index="'+to_mark+'"]').toggleClass("flagged");
        });
});

        $(document).ready(function() {
            $('#contacts').DataTable(
              );
        } );